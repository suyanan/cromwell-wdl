version 1.0

task svcalling {
    input {
        String project_id
        String sample_id
        String ref_version        
        File bam
        String aligner
        String svcaller
        String svcall_dir
        String docker_image
        String mem_size
        String num_cpu
    }

    command {
        umask 000 
        set -xve
        set -o pipefail
        echo 'svcall'
        if [ ! -d ${svcall_dir} ];then
            mkdir -p ${svcall_dir}
        fi
        ${svcaller} --report_BND --ignore_sd -q 0 -n -1 -t ${num_cpu} -l 50 -s 1 --genotype -m ${bam} -v ${svcall_dir}/${project_id}.${sample_id}.${aligner}.${ref_version}.${svcaller}.vcf           
    }

    output {
        File vcf = "${svcall_dir}/${project_id}.${sample_id}.${aligner}.${ref_version}.${svcaller}.vcf"
    }

    runtime {
        docker: docker_image
        memory: mem_size
        cpu: num_cpu
    }
}
