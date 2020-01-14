workflow es {    
    File bed
    String local_docker
    String local_mem
    String local_cpu
    
    call localdbsv {
        input:
            bed_file = bed,
            docker_image = local_docker,
            mem_size = local_mem,
            num_cpu = local_cpu
    }    
}


task localdbsv {    
    File bed_file        
    String docker_image
    String mem_size
    String num_cpu    
    
    command {
        umask 000
        set -xve    
        set -o pipefail                
        echo 'local'
        touch hello
        python /dbsv-es-demos/es.py --input ${bed_file} --outdir ./
    }   
    
    output {
        String out = read_string(stdout())
    }

    runtime {
        docker: docker_image
        memory: mem_size
        cpu: num_cpu
    }    
}




