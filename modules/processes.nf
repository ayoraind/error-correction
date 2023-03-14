process MEDAKA_FIRST_ITERATION {
    tag "error correction of $meta assemblies"
    
    errorStrategy 'ignore'
    
    // publishDir "${params.output_dir}", mode:'copy'
    
    conda '/MIGE/01_DATA/07_TOOLS_AND_SOFTWARE/nextflow_pipelines/error-correction/medaka_env.yml'
    // when used outside the TAPIR network, simply edit the code and use conda '../medaka_env.yml)'
    
    input:
    tuple val(meta), path(reads), path(assembly)

    output:
    tuple val(meta), path("${meta}.fasta"), emit: first_iteration_ch
    path "versions.yml"                   , emit: versions_ch

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta}"
    """
    medaka_consensus -t $task.cpus $args -i $reads -d $assembly -m r941_min_hac_g507 -o .
    
    mv consensus.fasta ${prefix}.fasta
    
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        medaka: \$( medaka --version 2>&1 | sed 's/medaka //g' )
    END_VERSIONS
    """
}


process MEDAKA_SECOND_ITERATION_FOR_FLYE_ASSEMBLIES {
    tag "error correction of $meta assemblies"
    
    publishDir "${params.output_dir}/${meta}_FLYE_MEDAKA", mode:'copy'
    
    errorStrategy 'ignore'
    
    
    conda '/MIGE/01_DATA/07_TOOLS_AND_SOFTWARE/nextflow_pipelines/error-correction/medaka_env.yml'
    
    input:
    tuple val(meta), path(reads), path(assembly)

    output:
    tuple val(meta), path("${meta}.fasta"), emit: second_iteration_ch
    path "versions.yml"                   , emit: versions_ch

    when:
    task.ext.when == null || task.ext.when
    

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta}"
    """
    medaka_consensus -t $task.cpus $args -i $reads -d $assembly -m r941_min_hac_g507 -o .
    
    mv consensus.fasta ${prefix}.fasta
    
    sed -i "s/^>/>${prefix}_/g" ${prefix}.fasta
    
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        medaka: \$( medaka --version 2>&1 | sed 's/medaka //g' )
    END_VERSIONS
    """
}

process MEDAKA_SECOND_ITERATION_FOR_SBERRY_ASSEMBLIES {
    tag "error correction of $meta assemblies"
    
    publishDir "${params.output_dir}/${meta}_FLYE_SBERRY_MEDAKA", mode:'copy'
    errorStrategy 'ignore'
    
    
    conda '/MIGE/01_DATA/07_TOOLS_AND_SOFTWARE/nextflow_pipelines/error-correction/medaka_env.yml'
    
    input:
    tuple val(meta), path(reads), path(assembly)

    output:
    tuple val(meta), path("${meta}.fasta"), emit: second_iteration_ch
    path "versions.yml"                   , emit: versions_ch

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta}"
    """
    medaka_consensus -t $task.cpus $args -i $reads -d $assembly -m r941_min_hac_g507 -o .
    
    mv consensus.fasta ${prefix}.fasta
    
    sed -i "s/^>/>${prefix}_/g" ${prefix}.fasta
    
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        medaka: \$( medaka --version 2>&1 | sed 's/medaka //g' )
    END_VERSIONS
    """
}
