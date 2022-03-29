import paho.mqtt.client as mqtt
import sys

MQTT_ADDRESS = '192.168.0.106'
MQTT_USER = 'erick'
MQTT_PASSWORD = '123'
MQTT_TOPIC = 'Temperatura: '
file_path = '/etc/mosquitto/teste.txt'


def on_connect(client, userdata, flags, rc):
    """ Busca dados vindos do servidor."""
   # print('Connected with result code ' + str(rc))
    client.subscribe(MQTT_TOPIC)

def on_message(client, userdata, msg):
    """Printa dados vindo do servidor."""
    data=(msg.topic + ' ' + str(msg.payload))
    f = open(file_path, 'w')
    print(data, file=f)

def main():
    mqtt_client = mqtt.Client()
    mqtt_client.username_pw_set(MQTT_USER, MQTT_PASSWORD)
    mqtt_client.on_connect = on_connect
    mqtt_client.on_message = on_message

    mqtt_client.connect(MQTT_ADDRESS, 1883)
    mqtt_client.loop_forever()


if __name__ == '__main__':
   # print('MQTT to InfluxDB bridge')
    main()
