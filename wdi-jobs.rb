require 'erb'
require 'date'

start_date =  Date.parse(ARGV[0])
end_date = Date.parse(ARGV[1])

def days(start_date,end_date)
  start_date.upto(end_date).to_a.map { |val| val.strftime('%Y-%m-%d') }
end

def template()
%{
---
apiVersion: batch/v1
kind: Job
metadata:
  name: wdi-<%= day %>
spec:
  template:
    metadata:
      name: wdi
    spec:
      containers:
      - name: wdi
        image: ahmadjawidjami/luftdaten_info_importer
        env:
        - name: "RESOURCE_URL"
          value: "http://archive.luftdaten.info/<%= day %>/"
        - name: "KAFKA_BOOTSTRAP_SERVERS"
          value: "kafka.kafka:9092"
        - name: "KAFKA_BROKER_LIST"
          value: "kafka-0.broker.kafka.svc.cluster.local:9092"
        - name: "KAFKA_TOPIC"
          value: "wdi"
      restartPolicy: Never
}
end


days(start_date,end_date).each do |day|
  b = binding
  b.local_variable_set(:day, day)
  puts output = ERB.new(template).result(b)
end
