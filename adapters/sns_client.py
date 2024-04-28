import boto3


class SNSClientAdapter:
    def __init__(self, region_name):
        self.client = boto3.client('sns', region_name=region_name)
    
    def publish_message(self, topic_arn, message):
        self.client.publish(TopicArn=topic_arn, Message=message, MessageStructure='string')
