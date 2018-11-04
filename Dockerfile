FROM pio-base-12:latest

ENV DEBIAN_FRONTEND noninteractive

ENV PIO_VERSION 0.12.1
ENV SPARK_VERSION 2.1.1
ENV HADOOP_VERSION 2.6
ENV SCALA_VERSION 2.11.12
ENV SCALA_MAJOR_VERSION 2.11
ENV SBT_VERSION 1.2.0
ENV JDBC_PG_VERSION 42.2.0
ENV UNIVERSAL_RECOMMENDER_VERSION v0.7.3

ENV PIO_HOME /home/pio
ENV PATH ${PIO_HOME}/bin:$PATH
ENV UR_HOME ${PIO_HOME}/universal-recommender
ENV APP_HOME ${PIO_HOME}/app
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Apache PredictionIO, Spark and JDBC PostgreSQL driver
# RUN curl -sSL https://archive.apache.org/dist/predictionio/${PIO_VERSION}/apache-predictionio-${PIO_VERSION}-bin.tar.gz | tar -xzpf - --strip-components=1 -C ${PIO_HOME}
RUN curl -sSL https://archive.apache.org/dist/predictionio/0.12.1/apache-predictionio-0.12.1-bin.tar.gz | tar -xzpf - --strip-components=1 -C ${PIO_HOME}
# RUN curl -sSL https://archive.apache.org/dist/predictionio/${PIO_VERSION}-incubating/apache-predictionio-${PIO_VERSION}-incubating.tar.gz | tar -xzpf - --strip-components=1 -C ${PIO_HOME}
# RUN curl -sSL http://apache.mirrors.pair.com/incubator/predictionio/${PIO_VERSION}-incubating/apache-predictionio-${PIO_VERSION}-incubating.tar.gz | tar -xzpf - --strip-components=1 -C ${PIO_HOME}

RUN  curl -sSL https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz | tar -xzpf - -C ${PIO_HOME}/vendors
# RUN  mkdir -p ${PIO_HOME}/lib
RUN  curl -sSL https://jdbc.postgresql.org/download/postgresql-${JDBC_PG_VERSION}.jar -o ${PIO_HOME}/lib/postgresql-${JDBC_PG_VERSION}.jar

WORKDIR ${UR_HOME}

# Universal Recommender build with sbt and scala
RUN  curl -sSL https://piccolo.link/sbt-${SBT_VERSION}.tgz | tar -xzpf - -C ${PIO_HOME}
RUN  curl -sSL https://github.com/actionml/universal-recommender/archive/${UNIVERSAL_RECOMMENDER_VERSION}.tar.gz | tar -xzpf - --strip-components=1 -C ${UR_HOME}
# RUN  pio build
# RUN  mv -vf ${UR_HOME}/target/scala-${SCALA_MAJOR_VERSION}/*.jar ${APP_HOME}/lib \
# &&  cp -vf ${UR_HOME}/engine.json.template ${APP_HOME}/engine.json \
# &&  cp -vf ${UR_HOME}/template.json ${APP_HOME}/template.json \
# &&  rm -rf ${UR_HOME} ~/.sbt ~/.ivy2/

# pio-env.sh
COPY conf/ ${PIO_HOME}/conf/
RUN chown -R pio:pio ${PIO_HOME}

WORKDIR ${APP_HOME}
USER pio
CMD ["pio"]
