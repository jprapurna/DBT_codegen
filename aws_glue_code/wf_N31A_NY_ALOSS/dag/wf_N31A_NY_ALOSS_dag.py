import os
from dagfactory import DagFactory

config_path = os.path.join(os.path.dirname(__file__), "wf_N31A_NY_ALOSS_dag.yml")
dag_factory = DagFactory(config_path)
dag_factory.generate_dags(globals())
