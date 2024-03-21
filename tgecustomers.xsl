<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:template match="/">
    <html>
      <head>
        <title>Customer Details</title>
      </head>
      <body>
        <h1>Customer Details</h1>
        <table border="1">
          <tr>
            <th>Customer ID</th>
            <th>First Name</th>
            <th>Last Name</th>
            <th>Street</th>
            <th>City</th>
            <th>State</th>
            <th>ZIP</th>
          </tr>
          <xsl:apply-templates select="customers/customer" />
        </table>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="customer">
    <tr>
      <td>
        <xsl:value-of select="@custID" />
      </td>
      <td>
        <xsl:value-of select="firstName" />
      </td>
      <td>
        <xsl:value-of select="lastName" />
      </td>
      <td>
        <xsl:value-of select="street" />
      </td>
      <td>
        <xsl:value-of select="city" />
      </td>
      <td>
        <xsl:value-of select="state" />
      </td>
      <td>
        <xsl:value-of select="ZIP" />
      </td>
    </tr>
  </xsl:template>

</xsl:stylesheet>

