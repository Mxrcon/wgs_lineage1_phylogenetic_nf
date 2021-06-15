//based on https://github.com/nf-modules/prokka/blob/master/main.nf
nextflow.enable.dsl = 2

/*
Old Inputs TODO

params.spadesResults = 'results/spades/*_scaffolds.fasta'
params.resultsDir = 'results/prokka'
params.saveMode = 'copy'

Channel.fromPath("""${params.spadesResults}""")
        .into { ch_in_prokka }
 */

process PROKKA {
    tag "${genomeName}"
    publishDir "${params.resultsDir}/prokka", mode: params.saveMode, enabled: params.shouldPublish

    input:
    tuple val(genomeName), file(bestContig)
    path(reference)

    output:
    path("${genomeName}")

    script:

    """
    prokka --outdir ${genomeName} --prefix ${genomeName} --cpus ${task.cpus} --proteins ${reference} --locustag ${genomeName} ${bestContig}
    """

    stub:

    """
    echo "prokka --outdir ${genomeName} --prefix $genomeName --cpus ${task.cpus} --proteins ${reference} --locustag ${genomeName} ${bestContig}"


    mkdir ${genomeName}

    """
}
