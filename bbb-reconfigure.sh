#!/bin/sh

#named_dir="/etc/namedb/master"
current_isp=`cat /usr/scripts/ch-gateway/current`
#named_dir="/"
#named_tpl="/etc/namedb/template"
vars_xml_templ="/usr/scripts/bbb/vars.xml.templ"
vars_xml="/opt/freeswitch/etc/freeswitch/vars.xml"
external_xml_templ="/usr/scripts/bbb/external.xml.templ"
external_xml="/opt/freeswitch/etc/freeswitch/sip_profiles/external.xml"
sip_nginx_templ="/usr/scripts/bbb/sip.nginx.templ"
sip_nginx="/etc/bigbluebutton/nginx/sip.nginx"
default_yml_templ="/usr/scripts/bbb/default.yml.templ"
default_yml="/usr/local/bigbluebutton/bbb-webrtc-sfu/config/default.yml"
#serial_new=`date "+%y%m%d%H%M"`
cur_date=`date --date="+5 minutes" --rfc-3339=seconds`
relant_ip="91.210.207.6"
elvis_ip="195.88.23.216"


if [ "x$current_isp" = "xrelant" ]; then
    #echo ${serial_new};
    #killall named

    cat ${vars_xml_templ} | sed "s/_iptempl_/${relant_ip}/" >${vars_xml};
    cat ${external_xml_templ} | sed "s/_iptempl_/${relant_ip}/" >${external_xml};
    cat ${sip_nginx_templ} | sed "s/_iptempl_/${relant_ip}/" >${sip_nginx};
    cat ${default_yml_templ} | sed "s/_iptempl_/${relant_ip}/" >${default_yml};
    echo ${cur_date}" BBB configs have been updated to Relant ext IP!" >> /var/log/bbb_config_update.log;
    #/usr/sbin/rndc reload;
else
    if [ "x$current_isp" = "xelvis" ]; then
    #echo ${serial_new};
    #killall named
    cat ${vars_xml_templ} | sed "s/_iptempl_/${elvis_ip}/" >${vars_xml};
    cat ${external_xml_templ} | sed "s/_iptempl_/${elvis_ip}/" >${external_xml};
    cat ${sip_nginx_templ} | sed "s/_iptempl_/${elvis_ip}/" >${sip_nginx};
    cat ${default_yml_templ} | sed "s/_iptempl_/${elvis_ip}/" >${default_yml};
    #/usr/sbin/rndc reload;
    echo ${cur_date}" BBB configs have been updated to Elvis ext IP!" >> /var/log/bbb_config_update.log;
    fi
fi

bbb-conf --restart
service freeswitch restart
echo ${cur_date}" BBB and FreeSwitch have been restarted!" >> /var/log/bbb_config_update.log;
