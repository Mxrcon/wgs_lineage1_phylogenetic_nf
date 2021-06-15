// based on https://github.com/nf-modules/trimmomatic.git
nextflow.enable.dsl =2

process TRIMMOMATIC {
    tag "${genomeName}"
    publishDir "${params.resultsDir}/trimmed_reads", mode: params.saveMode, enabled: params.shouldPublish

    input:
    tuple val(genomeName), path(genomeReads)

    output:
    tuple val(genomeName), file("*_{R1,R2}.p.fastq.gz"), emit: trimmed_reads

    script:

    fq_1_paired = genomeName + '_R1.p.fastq.gz'
    fq_1_unpaired = genomeName + '_R1.s.fastq.gz'
    fq_2_paired = genomeName + '_R2.p.fastq.gz'
    fq_2_unpaired = genomeName + '_R2.s.fastq.gz'

    def adapterFile = "/usr/local/share/trimmomatic-0.35-6/adapters/NexteraPE-PE.fa"

    """
    trimmomatic \
    PE \
    -threads ${task.cpus} \
    -phred33 \
    ${genomeReads[0]} \
    ${genomeReads[1]} \
    $fq_1_paired \
    $fq_1_unpaired \
    $fq_2_paired \
    $fq_2_unpaired \
    ILLUMINACLIP:${adapterFile}:2:40:15  \
    LEADING:3 TRAILING:3 SLIDINGWINDOW:3:28 HEADCROP:20 MINLEN:40
    """

    stub:
    fq_1_paired = genomeName + '_R1.p.fastq.gz'
    fq_1_unpaired = genomeName + '_R1.s.fastq.gz'
    fq_2_paired = genomeName + '_R2.p.fastq.gz'
    fq_2_unpaired = genomeName + '_R2.s.fastq.gz'

    adapterFile = "/usr/local/share/trimmomatic-0.35-6/adapters/NexteraPE-PE.fa"

    """
    echo "trimmomatic \
    PE \
    -threads ${task.cpus} \
    -phred33 \
    ${genomeReads[0]} \
    ${genomeReads[1]} \
    $fq_1_paired \
    $fq_1_unpaired \
    $fq_2_paired \
    $fq_2_unpaired \
    ILLUMINACLIP:${adapterFile}:2:40:15  \
    LEADING:3 TRAILING:3 SLIDINGWINDOW:3:28 HEADCROP:20 MINLEN:40"

    touch ${genomeName}_R1.p.fastq.gz
    touch ${genomeName}_R2.p.fastq.gz

    """
}

