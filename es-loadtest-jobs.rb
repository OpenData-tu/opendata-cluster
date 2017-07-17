require 'erb'
require 'date'

jobs_count =  (ARGV[0]).to_i

def template()
%{
---
apiVersion: batch/v1
kind: Job
metadata:
  name: "es-<%= num %>"
  labels:
    job: "es-loadtest"
spec:
  template:
    metadata:
      name: "es-loadtest"
    spec:
      containers:
      - name: "es-loadtest"
        image: masonvx/elasticwritetest:v0.1
        env:
        - name: ES_URL
          value: "elasticsearch:9200"
        - name: ES_INDEX
          value: "loadtest"
        - name: BATCH_SIZE
          value: "1000"
        - name: REPEATS
          value: "10000"
        resources:
          limits:
            memory: 700Mi
          requests:
            memory: 500Mi
      restartPolicy: Never
}
end


jobs_count.times do |num|
  b = binding
  b.local_variable_set(:num, num)
  puts output = ERB.new(template).result(b)
end
