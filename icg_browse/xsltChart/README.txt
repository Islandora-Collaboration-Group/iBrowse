XSLT Charts

chart.xslt - The xsl transform stylesheet
chart.xslz - chart.xslt gzip compressed (<5KB)

Those using apache may find these .htaccess entries useful, especially if using chart.xslz:
 
AddType image/svg+xml .svg
AddType image/svg+xml .svgz
AddType application/xslt+xml .xsl .xslt .xslz .xsltz
AddEncoding gzip .svgz 
AddEncoding gzip .xslz .xsltz

For more information see: http://www.xsltcharts.com
