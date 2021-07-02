# https://makefiletutorial.com/

run_stub:
	bash ./data/mock_data/generate_mock_files.sh && nextflow run main.nf -profile stub -stub-run

run_local:
	nextflow run main.nf -params-file params/standard.yml -resume -with-tower
