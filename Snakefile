
#configfile: "config/YYYY_MM_DD_config.yaml"

config_path=config['config_path']
DATE = config['date']
PROJ_NAME = config['project_name']
OUT_F = config['output_file']

#snakemake -s Snakefile --delete-all-output -c 1

rule all:
  input:
    expand("data/processed/{date}/.done", date=DATE),
    expand("plots/{date}/.done", date=DATE),
    # this file gets deleted when rendering
    #expand("reports/{date}/.done", date=DATE),
    expand("reports/{date}/{out_file}", date=DATE,out_file=OUT_F)

rule make_dirs:
  output:
    expand("data/processed/{date}/.done", date=DATE),
    expand("plots/{date}/.done", date=DATE),
    expand("reports/{date}/.done", date=DATE)
  shell:
    """
    for d in {DATE}; do
      mkdir -p data/processed/$d
      mkdir -p plots/$d
      mkdir -p reports/$d
    done
    
    touch {output}
    """

rule render_quarto:
  params:
    config_p=config_path,
    d=expand("{date}",date=DATE),
    t=expand("{PROJ_NAME}",PROJ_NAME=PROJ_NAME),
    out=expand("{OUT_F}",OUT_F=OUT_F)
  input:
    expand("reports/{date}/.done",date=DATE)
  output:
    expand("reports/{date}/{out_file}",date=DATE, out_file=OUT_F)
  shell:
    """
    quarto render report_template.qmd \
    -P title={params.t} \
    -P config={params.config_p} \
    --output-dir reports/{params.d}/ \
    -o {params.out}
    """
