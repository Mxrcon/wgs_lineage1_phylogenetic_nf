nextflow.enable.dsl = 2

include { EXPORT_RAW_GENOMES } from "./modules/export_raw_genomes/export_raw_genomes.nf"
include { FASTQC_ORIGINAL } from "./modules/fastqc/fastqc.nf"
include { FASTQC_TRIMMED } from "./modules/fastqc/fastqc.nf"
include { MTBSEQ_PER_SAMPLE } from "./modules/mtbseq/mtbseq.nf"
include { MULTIQC_ORIGINAL } from "./modules/multiqc/multiqc.nf"
include { MULTIQC_TRIMMED } from "./modules/multiqc/multiqc.nf"
include { PROKKA } from "./modules/prokka/prokka.nf"
include { RD_ANALYZER } from "./modules/rd_analyzer/rd_analyzer.nf"
include { SPADES } from "./modules/spades/spades.nf"
include { SPOTYPING } from "./modules/spotyping/spotyping.nf"
include { TBPROFILER_COLLATE } from "./modules/tb_profiler/tb_profiler.nf"
include { TBPROFILER_PROFILE } from "./modules/tb_profiler/tb_profiler.nf"
include { TRIMMOMATIC } from "./modules/trimmomatic/trimmomatic.nf"

workflow {

// Data Input
	if (params.inputType == "reads") {
		input_ch = Channel.fromFilePairs(params.reads)}

	if (params.inputType == "sra") {
		input_ch = Channel.fromSRA(params.genomeIds, cache: true, apiKey: params.apiKey)}

	if (params.inputType == "bucket") {
		input_ch = Channel.fromFilePairs(file(params.reads))}

	input_ch.view()
//Export Genomes
	EXPORT_RAW_GENOMES(input_ch)
// Quality control
	FASTQC_ORIGINAL(input_ch)
	MULTIQC_ORIGINAL(FASTQC_ORIGINAL.out.flatten().collect())
	TRIMMOMATIC(input_ch)
	FASTQC_TRIMMED(TRIMMOMATIC.out.trimmed_reads)
	MULTIQC_TRIMMED(FASTQC_TRIMMED.out.flatten().collect())
// Analysis
//	MTBSEQ_PER_SAMPLE(TRIMMOMATIC.out./*FIXME*/,gatkjar_ch)
	SPADES(TRIMMOMATIC.out.trimmed_reads)
	SPOTYPING(TRIMMOMATIC.out.trimmed_reads)
	TBPROFILER_PROFILE(TRIMMOMATIC.out.trimmed_reads)
	TBPROFILER_COLLATE(TBPROFILER_PROFILE.out[0].flatten().collect())
	PROKKA(SPADES.out.prokka_contigs,params.reference)
	RD_ANALYZER(TRIMMOMATIC.out.trimmed_reads)


}
