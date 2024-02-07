# Llama.cpp in a container

Using the great work at [LLama.cpp](https://github.com/ggerganov/llama.cpp/tree/master) @ [Version](https://github.com/ggerganov/llama.cpp/releases/tag/b1662)
## To Build 
```
podman build . -f containerfile
```

## To Run

Download a gguf model from Huggingface (or build your own) and mount the location into the container.

```
podman run --rm -e MODELNAME=phi-2.Q4_K_M.gguf -v /home/noelo/dev/llm-models:/tmp/models:Z -p 8080:8080 quay.io/noeloc/llamacpp
```

## To execute a request
```bash
 ~/dev/llm-models  curl --request POST     --url http://127.0.0.1:8080/completion     --header "Content-Type: application/json"     --data '{"prompt": "Building a website can be done in 10 simple steps:","n_predict": 128}'

{"content":"\n1. Plan and design: Determine the purpose of your website, its target audience, and create a layout or wireframe.\n2. Choose a domain name and hosting service: Select a unique and memorable domain name, and choose a reliable hosting provider for your website.\n3. Create and edit HTML files: Use HTML to structure your website's content, including headings, paragraphs, lists, and images.\n4. Add CSS stylesheets: Apply CSS to customize the appearance of your website, such as font sizes, colors, layout, and formatting.\n5. Write and publish JavaScript code: Use JavaScript for interactive","generation_settings":{"frequency_penalty":0.0,"grammar":"","ignore_eos":false,"logit_bias":[],"min_p":0.05000000074505806,"mirostat":0,"mirostat_eta":0.10000000149011612,"mirostat_tau":5.0,"model":"/tmp/models/phi-2.Q4_K_M.gguf","n_ctx":512,"n_keep":0,"n_predict":128,"n_probs":0,"penalize_nl":true,"presence_penalty":0.0,"repeat_last_n":64,"repeat_penalty":1.100000023841858,"seed":4294967295,"stop":[],"stream":false,"temp":0.800000011920929,"tfs_z":1.0,"top_k":40,"top_p":0.949999988079071,"typical_p":1.0},"model":"/tmp/models/phi-2.Q4_K_M.gguf","prompt":"Building a website can be done in 10 simple steps:","slot_id":0,"stop":true,"stopped_eos":false,"stopped_limit":true,"stopped_word":false,"stopping_word":"","timings":{"predicted_ms":16142.462,"predicted_n":128,"predicted_per_second":7.929397634635906,"predicted_per_token_ms":126.112984375,"prompt_ms":588.103,"prompt_n":11,"prompt_per_second":18.704206576058958,"prompt_per_token_ms":53.463909090909084},"tokens_cached":139,"tokens_evaluated":11,"tokens_predicted":128,"truncated":false}
```

## Deployment on OpenShift

The OCP resources to be deployed are stored in the _ocp-resources_ directory. 

The models need to be downloaded and stored into the _model-store_ PV.

The _model name_ then needs to be defined in the _MODELNAME_ environment variable.

```bash
oc set env deployment/llamacpp MODELNAME=llama-2-7b-chat.Q4_K_M.gguf
```

To send a request to the LLM use the following command:

```bash
curl --request POST --url https://ocphostname.com/completion  --header "Content-Type: application/json" --data '{"prompt": "write me a funny poem :","n_predict": 128}'
```

## Other stuff

Embeddings are disable by default so use _EMBEDDINGS="--embedding"_ environment variable to enable.

Context size by default is *512* to change set the _CONTEXTSIZE_ environment variable. 

Model file location is set via the _MODELLOCATION_ environment variable, it defaults to _/tmp/models_.

OpenBlas acceleration isn't yet working

### Tested with the following models:

* https://huggingface.co/TheBloke/Llama-2-7B-Chat-GGUF/blob/main/llama-2-7b-chat.Q4_K_M.gguf
* https://huggingface.co/TheBloke/phi-2-GGUF/blob/main/phi-2.Q4_K_M.gguf