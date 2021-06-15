// based on https://github.com/nf-modules/fastqc
nextflow.enable.dsl = 2

process FASTQC_ORIGINAL {
    tag "${genomeName}"
    publishDir "${params.resultsDir}/fastqc/original", mode: params.saveMode, enabled: params.shouldPublish

    input:
    tuple val(genomeName), path(genomeReads)

    output:
    tuple file('*.html'), file('*.zip')


    script:

    """
    fastqc *fastq*
    """

    stub:

    """
    echo "fastqc *fastq*"

    mkdir ${genomeName}
    touch ${genomeName}.html
    touch ${genomeName}.zip
    """
}

process FASTQC_TRIMMED {
    tag "${genomeName}"
    publishDir "${params.resultsDir}/fastqc/trimmed", mode: params.saveMode, enabled: params.shouldPublish

    input:
    tuple val(genomeName), file(genomeReads)

    output:
    tuple file('*.html'), file('*.zip')


    script:

    """
    fastqc *fastq*
    """

    stub:

    """
    echo "fastqc *fastq*"

    mkdir ${genomeName}
    touch ${genomeName}.html
    touch ${genomeName}.zip
    """
}
