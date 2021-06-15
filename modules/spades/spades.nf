// based on https://github.com/nf-modules/spades/
nextflow.enable.dsl = 2

process SPADES {
    tag "${genomeName}"
    publishDir "${params.resultsDir}/spades", mode: params.saveMode, enabled: params.shouldPublish

    input:
    tuple val(genomeName), file(genomeReads)

    output:
    tuple val(genomeName), file("*_contigs.fasta"), emit: prokka_contigs


    script:

    """
    spades.py -k 21,33,55,77 --careful --only-assembler --pe1-1 ${genomeReads[0]} --pe1-2 ${genomeReads[1]} -o ${genomeName} -t ${task.cpus}
    cp ${genomeName}/contigs.fasta ${genomeName}_contigs.fasta
    """

    stub:
    """
    echo  "spades.py -k 21,33,55,77 --careful --only-assembler --pe1-1 ${genomeReads[0]} --pe1-2 ${genomeReads[1]} -o ${genomeName} -t ${task.cpus}"

    touch ${genomeName}_contigs.fasta
    """
}
