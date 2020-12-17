#!/bin/sh
# drlight 17.12.2020 Script to change config of BBB with new ip address depend on current ISP

current_isp=`cat /usr/scripts/ch-gateway/current`
vars_xml_templ="/usr/scripts/bbb/vars.xml.templ"
vars_xml="/opt/freeswitch/etc/freeswitch/vars.xml"
external_xml_templ="/usr/scripts/bbb/external.xml.templ"
external_xml="/opt/freeswitch/etc/freeswitch/sip_profiles/external.xml"
sip_nginx_templ="/usr/scripts/bbb/sip.nginx.templ"
sip_nginx="/etc/bigbluebutton/nginx/sip.nginx"
default_yml_templ="/usr/scripts/bbb/default.yml.templ"
default_yml="/usr/local/bigbluebutton/bbb-webrtc-sfu/config/default.yml"
default_bbb_sip_templ="/usr/scripts/bbb/bigbluebutton-sip.properties.templ"
default_bbb_sip="/usr/share/red5/webapps/sip/WEB-INF/bigbluebutton-sip.properties"
cur_date=`date --date="+5 minutes" --rfc-3339=seconds`
ISP1_ip="xxx.xxx.xxx.xxx"
ISP2_ip="yyy.yyy.yyy.yyy"

if [ "x$current_isp" = "xisp1" ]; then
    cat ${vars_xml_templ} | sed "s/_iptempl_/${ISP1_ip}/" >${vars_xml};
    cat ${external_xml_templ} | sed "s/_iptempl_/${ISP1_ip}/" >${external_xml};
    cat ${sip_nginx_templ} | sed "s/_iptempl_/${ISP1_ip}/" >${sip_nginx};
    cat ${default_yml_templ} | sed "s/_iptempl_/${ISP1_ip}/" >${default_yml};
    cat ${default_bbb_sip_templ} | sed "s/_iptempl_/${ISP1_ip}/" >${default_bbb_sip};
    echo ${cur_date}" BBB configs have been updated to ISP1 ext IP!" >> /var/log/bbb_config_update.log;
else
    if [ "x$current_isp" = "xisp2" ]; then
    cat ${vars_xml_templ} | sed "s/_iptempl_/${ISP2_ip}/" >${vars_xml};
    cat ${external_xml_templ} | sed "s/_iptempl_/${ISP2_ip}/" >${external_xml};
    cat ${sip_nginx_templ} | sed "s/_iptempl_/${ISP2_ip}/" >${sip_nginx};
    cat ${default_yml_templ} | sed "s/_iptempl_/${ISP2_ip}/" >${default_yml};
    cat ${default_bbb_sip_templ} | sed "s/_iptempl_/${ISP2_ip}/" >${default_bbb_sip};
    echo ${cur_date}" BBB configs have been updated to ISP2 ext IP!" >> /var/log/bbb_config_update.log;
    fi
fi

bbb-conf --restart
service freeswitch restart
echo ${cur_date}" BBB and FreeSwitch have been restarted!" >> /var/log/bbb_config_update.log; 
