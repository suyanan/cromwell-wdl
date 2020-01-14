version 1.0

task alignment {
    input {
        String project_id
        String sample_id        
        File fastqFile
        File ref
        String ref_version        
        String aligner
        String align_dir        
        String docker_image
        String mem_size
        String num_cpu        
    }
    
    command {
        umask 000
        set -xve    
        set -o pipefail                
        echo 'align'
        if [ ! -d ${align_dir} ];then
            mkdir -p ${align_dir}
        fi
        touch hello
        #${aligner} -t ${num_cpu} -x ont -r ${ref} -q ${fastqFile} -o ${align_dir}/${project_id}.${sample_id}.${aligner}.${ref_version}.merged.raw.bam 
        #samtools sort --threads ${num_cpu} ${align_dir}/${project_id}.${sample_id}.${aligner}.${ref_version}.merged.raw.bam -o ${align_dir}/${project_id}.${sample_id}.${aligner}.${ref_version}.merged.bam
        #samtools index ${align_dir}/${project_id}.${sample_id}.${aligner}.${ref_version}.merged.bam
        #rm -f ${align_dir}/${project_id}.${sample_id}.${aligner}.${ref_version}.merged.raw.bam 
    }
    
    output {
        File bam = "${align_dir}/${project_id}.${sample_id}.${aligner}.${ref_version}.merged.bam"        
    }
    
    runtime {
        docker: docker_image
        memory: mem_size
        cpu: num_cpu
    }    
}