nextflow.enable.dsl = 2

process MULTIQC_ORIGINAL {
    publishDir "${params.resultsDir}/multiqc/original", mode: params.saveMode, enabled: params.shouldPublish

    input:
    file("*")

    output:
    tuple path("""multiqc_data"""),
            path("""multiqc_report.html""")


    script:

    """
    multiqc .
    """

    stub:
    """
    mkdir multiqc_data

    touch multiqc_report.html
    """
}

process MULTIQC_TRIMMED {
    publishDir "${params.resultsDir}/multiqc/trimmed", mode: params.saveMode, enabled: params.shouldPublish

    input:
    file("*")

    output:
    tuple path("""multiqc_data"""),
            path("""multiqc_report.html""")


    script:

    """
    multiqc .
    """

    stub:
    """
    mkdir multiqc_data

    touch multiqc_report.html
    """
}
