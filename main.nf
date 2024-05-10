nextflow.enable.dsl = 2

include { EXPORT_RAW_GENOMES } from "./modules/export_raw_genomes/export_raw_genomes.nf"
include { FASTQC as FASTQC_ORIGINAL } from "./modules/fastqc/fastqc.nf" addParams(resultsDir: "${params.outdir}/fastqc/original")
include { FASTQC as FASTQC_TRIMMED } from "./modules/fastqc/fastqc.nf" addParams(resultsDir: "${params.outdir}/fastqc/trimmed")
include { MULTIQC as MULTIQC_ORIGINAL } from "./modules/multiqc/multiqc.nf" addParams(resultsDir: "${params.outdir}/multiqc/original")
include { MULTIQC as MULTIQC_TRIMMED } from "./modules/multiqc/multiqc.nf" addParams(resultsDir: "${params.outdir}/multiqc/trimmed")
include { PROKKA } from "./modules/prokka/prokka.nf"
include { RD_ANALYZER } from "./modules/rd_analyzer/rd_analyzer.nf"
include { SPADES } from "./modules/spades/spades.nf"
include { SPOTYPING } from "./modules/spotyping/spotyping.nf"
include { TBPROFILER_COLLATE } from "./modules/tbprofiler/collate.nf"
include { TBPROFILER_PROFILE } from "./modules/tbprofiler/profile.nf"
include { TRIMMOMATIC } from "./modules/trimmomatic/trimmomatic.nf"

workflow {

// Data Input
    if (params.input_type == "reads") {
        input_ch = Channel.fromFilePairs(params.reads,checkIfExists: true)}

    if (params.input_type == "sra") {
        input_ch = Channel.fromSRA(params.genome_ids, cache: true, apiKey: params.api_key)}


//Export Genomes
    EXPORT_RAW_GENOMES(input_ch)
// Quality control
    FASTQC_ORIGINAL(input_ch)
    MULTIQC_ORIGINAL(FASTQC_ORIGINAL.out.flatten().collect())
    TRIMMOMATIC(input_ch)
    FASTQC_TRIMMED(TRIMMOMATIC.out.trimmed_reads)
    MULTIQC_TRIMMED(FASTQC_TRIMMED.out.flatten().collect())
//	Analysis

    SPADES(TRIMMOMATIC.out.trimmed_reads)
    SPOTYPING(TRIMMOMATIC.out.trimmed_reads)
    TBPROFILER_PROFILE(TRIMMOMATIC.out.trimmed_reads)
    TBPROFILER_COLLATE(TBPROFILER_PROFILE.out[1].flatten().collect())
    PROKKA(SPADES.out.prokka_contigs,params.reference)
    RD_ANALYZER(TRIMMOMATIC.out.trimmed_reads)


}
