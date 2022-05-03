# dna-aws-infrae

Proyecto Terraform para infracestructura del challenge técnico implementado en la nube de AWS.
**Componentes**

![image](https://user-images.githubusercontent.com/5661155/166401868-5c34589c-f50f-4d4a-8702-14e7ba396cd3.png)

 - **API Gateway** `detector`
	 - /mutant (post)
		 - Endpoint: https://l2u6c81unj.execute-api.us-east-1.amazonaws.com/detector-stage/mutant
		 - Payload: `{"dna":["TTGCGA","CTGTAC","ATTAGT","AGATGG","ACCCTA","ACCCCG"]}`
		 - Response: `{"isMutant": true}`
		 
	 - /stats (get):
		 - Endpoint: https://l2u6c81unj.execute-api.us-east-1.amazonaws.com/detector-stage/stats
		 - Response: `{"count_mutant_dna": 1,"count_human_dna": 1,"ratio": 1}`
		 
 - **Tabla DynamoDB** `applicants`
 - **Lambda** `dna-evaluator`: Lambda que representa el endpoint */mutant* el cual realiza el análisis de ADN para determinar si es un mutante.
 	- Repositorio: https://github.com/sigi2488-coder/dna-evaluator-lambda
 - **Lambda** `dna-stats`: Lambda que consulta y genera las estadística de los registros. Endpoint /stats.
  	- Repositorio: https://github.com/sigi2488-coder/dna-stats-lambda
 - **S3** `dna-bucket-sources`: Bucket para almacenar el código fuente de las lambdas. Se utiliza en la etapa de despliegue.
