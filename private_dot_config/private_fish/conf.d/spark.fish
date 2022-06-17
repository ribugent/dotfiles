set -x SPARK_HOME /home/ribu/local/spark-3.2.1-bin-hadoop2.7
set -x PYSPARK_SUBMIT_ARGS --packages io.delta:delta-core_2.12:1.2.+,org.elasticsearch:elasticsearch-spark-30_2.12:8.2.3  --conf "spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension" --conf "spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog" pyspark-shell
