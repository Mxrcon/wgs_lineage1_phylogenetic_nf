nextflow.enable.dsl = 2

process EXPORT_RAW_GENOMES {
	tag "${genomeName}"
	publishDir "${params.resultsDir}/raw_genomes", mode: params.saveMode
	errorStrategy 'ignore'

    input:
    tuple val(genomeName), path(genomeReads)

    output:
    file(genomeReads)

    script:
    """
    """

    stub:
    """
    """

}
