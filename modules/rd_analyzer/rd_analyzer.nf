nextflow.enable.dsl = 2

process RD_ANALYZER {
    tag "${genomeName}"
    publishDir "${params.resultsDir}/rd_analyzer", mode: params.saveMode, enabled: params.shouldPublish


    input:
    tuple val(genomeName), file(genomeReads)

    output:
    tuple path("*result"), path("*depth")


    script:

    """
    python  /RD-Analyzer/RD-Analyzer.py  -o ${genomeName} ${genomeReads[0]} ${genomeReads[1]}
    """

    stub:
    """
    echo "python /RD-Analyzer/RD-Analyzer.py -o ${genomeName} ${genomeReads[0]} ${genomeReads[1]}"

    touch ${genomeName}.result
    touch ${genomeName}.depth
    """

}
