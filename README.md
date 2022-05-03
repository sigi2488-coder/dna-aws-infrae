# dna-aws-infrae

Es proyecto desarrollado en Terraform representa la infraestructura de la solución (IaC), la cual se desarrolla para AWS e implementa los siguientes componentes.

![image](https://user-images.githubusercontent.com/5661155/166401868-5c34589c-f50f-4d4a-8702-14e7ba396cd3.png)

 - **API Gateway** `detector`
	 - /mutant (post)
		 - Endpoint: https://l2u6c81unj.execute-api.us-east-1.amazonaws.com/detector-stage/stats
		 - Payload: `{"dna":["TTGCGA","CTGTAC","ATTAGT","AGATGG","ACCCTA","ACCCCG"]}`
		 - Response: `{"isMutant": true}`
		 
	 - /stats (get):
		 - Endpoint: https://l2u6c81unj.execute-api.us-east-1.amazonaws.com/detector-stage/stats
		 - Response: `{"count_mutant_dna": 1,"count_human_dna": 1,"ratio": 1}`
		 
 - **Tabla DynamoDB** `applicants`
 - **Lambda** `dna-evaluator`: Lambda que representa el endpoint */mutant* el cual realiza el análisis de ADN para determinar si es un mutante.
 - **Lambda** `dna-evaluator`: Lambda que consulta y genera las estadística de los registros. Endpoint /stats.
 - **S3** `dna-bucket-sources`: Bucket para almacenar el código fuente de las lambdas y posteriormente desplegar en la etapa de despliegue.
