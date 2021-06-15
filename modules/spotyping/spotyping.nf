//based on https://github.com/nf-modules/spotyping/blob/master/main.nf
nextflow.enable.dsl = 2

process SPOTYPING {
    tag "${genomeName}"
    publishDir "${params.resultsDir}/spotyping", mode: params.saveMode, enabled: params.shouldPublish

    input:
    tuple val(genomeName), file(genomeReads)

    output:
    tuple file('*.txt'), file('SITVIT*.xls')

    script:

    """
    python /SpoTyping-v2.0/SpoTyping-v2.0-commandLine/SpoTyping.py ./${genomeReads[0]} ./${genomeReads[1]} -o ${genomeName}.txt
    """

    stub:
    """
    echo "python /SpoTyping-v2.0/SpoTyping-v2.0-commandLine/SpoTyping.py ./${genomeReads[0]} ./${genomeReads[1]} -o ${genomeName}.txt"
    touch ${genomeName}.txt
    touch SITVIT_${genomeName}.xls
    """

}
