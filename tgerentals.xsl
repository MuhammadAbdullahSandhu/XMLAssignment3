<?xml version="1.0" encoding="UTF-8" ?>



<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:array="http://www.w3.org/2005/xpath-functions/array"
                xmlns:tgerentals="tgerentals">
   <xsl:output method="html"
               doctype-system="about:legacy-compat"
               encoding="UTF-8"
               indent="yes" />
               
               

	   
	<xsl:variable name="customersXML" as="node()" select="document('tgecustomers.xml')/customers"/>
    <xsl:variable name="toolsXML" as="node()" select="document('tgetools.xml')/equipment"/>
   
   <xsl:template match="/">
      <html lang="en-US">
         <title>The Good Earth - Current Rentals</title>
         <meta name="viewport" content="width=device-width,initial-scale=1"/>
         <head><link rel="stylesheet" href="styles.css"/></head>
         <body>
            <img src="tgelogo.png" alt="company logo"/>
            <hr/>
            <h1>Current Rentals</h1>
			 <xsl:for-each-group select="/rentals/rental" group-by="Start_Date" >
               <xsl:variable name="currentDateGroup" as="xs:string" select="format-date(Start_Date, '[MNn, 3-3] [D01], [Y0001]')"/>
               <h3><xsl:value-of select="$currentDateGroup"/></h3>
               
               <table>
                  <tr>
                     <th>Customer</th>
                     <th>Tool ID</th>
                     <th>Tool</th>
                     <th>Category</th>
                     <th>Due Date</th>
                     <th>Due Charges</th>
                  </tr>
                  
                  <xsl:for-each select="current-group()">
                     <xsl:variable name="CustID" as="text()" select="Customer/text()"/>
                     <xsl:variable name="ToolID" as="text()" select="Tool/text()"/>
                     <xsl:variable name="CustomerDetails" as="node()" select="$customersXML/customer[@custID=$CustID]"/>
                     <xsl:variable name="ToolDetails" as="node()" select="$toolsXML/tool[@toolID=$ToolID]"/>
                     <xsl:variable name="custName" as="xs:string" select="concat($CustomerDetails/firstName, ' ', $CustomerDetails/lastName)"/>
                     <xsl:variable name="cityAndState" as="xs:string" select="concat($CustomerDetails/city, ', ',$CustomerDetails/state, ' ', $CustomerDetails/ZIP)"/>
                     <xsl:variable name="Due_Date" as="xs:string" select="tgerentals:calculateDueDate(Start_Date, Weeks, Days)"/>
                     <xsl:variable name="Due_Charge" as="xs:float" select="tgerentals:calculateDueCharge(Weeks, $ToolDetails/weeklyRate, Days, $ToolDetails/dailyRate)"/>
                     
                     <tr>
                        <td>
                           <xsl:value-of select="$custName"/> <br/> 
                           <xsl:value-of select="$CustomerDetails/street"/> <br/> 
                           <xsl:value-of select="$cityAndState"/>
                        </td>
                        
                        <td><xsl:value-of select="Tool"/></td>
                        <td><xsl:value-of select="
                              $ToolDetails/description"/></td> 
                        <td><xsl:value-of select="$ToolDetails/category"/></td>
                        <td><xsl:value-of select="$Due_Date"/></td>
                        <td> <span id="dollarSign">$ </span> <xsl:value-of select="$Due_Charge"/></td> 
                     </tr>
                     
                     
                  </xsl:for-each>
               </table>
               
            </xsl:for-each-group>
         </body>
      </html>
   </xsl:template>
   
   
 
   <xsl:function name="tgerentals:calculateDueDate" as="xs:string">
      <xsl:param name="Start_Date"/>
      <xsl:param name="Duration_Weeks"/>
      <xsl:param name="Duration_Days"/>
      <xsl:value-of select="
         format-date(xs:date($Start_Date) + xs:dayTimeDuration(concat('P', $Duration_Weeks * 7 + $Duration_Days, 'D')), '[MNn, 3-3] [D01], [Y0001]')
                     "/>
   </xsl:function>
   <xsl:function name="tgerentals:calculateDueCharge" as="xs:float">
      <xsl:param name="Duration_Weeks" as="xs:integer"/>
      <xsl:param name="Duration_Days" as="xs:integer"/>
      <xsl:param name="Weekly_Rate" as="xs:integer"/>
      <xsl:param name="Daily_Rate" as="xs:integer"/>
      <xsl:value-of select="
         xs:float(($Duration_Weeks*$Weekly_Rate) + ($Duration_Days*$Daily_Rate))
                     "/>
   </xsl:function>
   
</xsl:stylesheet>
