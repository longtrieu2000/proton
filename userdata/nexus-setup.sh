#!/bin/bash
cd /tmp
wget https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.13%2B11/OpenJDK17U-jdk_x64_linux_hotspot_17.0.13_11.tar.gz -O temurin17.tar.gz
sudo mkdir -p /opt/temurin
sudo tar -xvzf temurin17.tar.gz -C /opt/temurin --strip-components=1
echo 'export JAVA_HOME=/opt/temurin' | sudo tee -a /etc/profile.d/jdk.sh
echo 'export PATH=$JAVA_HOME/bin:$PATH' | sudo tee -a /etc/profile.d/jdk.sh
sudo chmod +x /etc/profile.d/jdk.sh
source /etc/profile.d/jdk.sh
####chon phien ban java #####
#sudo update-alternatives --install /usr/bin/java java /opt/temurin/bin/java 1
#sudo update-alternatives --install /usr/bin/javac javac /opt/temurin/bin/javac 1
#sudo update-alternatives --config java


mkdir -p /opt/nexus/   
mkdir -p /tmp/nexus/                           
cd /tmp/nexus/
NEXUSURL="https://download.sonatype.com/nexus/3/nexus-unix-aarch64-3.78.1-02.tar.gz"
wget $NEXUSURL -O nexus.tar.gz
sleep 10
EXTOUT=`tar xzvf nexus.tar.gz`
NEXUSDIR=`echo $EXTOUT | cut -d '/' -f1`
sleep 5
rm -rf /tmp/nexus/nexus.tar.gz
cp -r /tmp/nexus/* /opt/nexus/
sleep 5
useradd nexus
chown -R nexus.nexus /opt/nexus 
cat <<EOT>> /etc/systemd/system/nexus.service
[Unit]                                                                          
Description=nexus service                                                       
After=network.target                                                            
                                                                  
[Service]                                                                       
Type=forking                                                                    
LimitNOFILE=65536                                                               
ExecStart=/opt/nexus/$NEXUSDIR/bin/nexus start                                  
ExecStop=/opt/nexus/$NEXUSDIR/bin/nexus stop                                    
User=nexus                                                                      
Restart=on-abort                                                                
                                                                  
[Install]                                                                       
WantedBy=multi-user.target                                                      

EOT

echo 'run_as_user="nexus"' > /opt/nexus/$NEXUSDIR/bin/nexus.rc
systemctl daemon-reload
systemctl start nexus
systemctl enable nexus
