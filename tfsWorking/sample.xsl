<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:foo="http://www.foo.org/" xmlns:bar="http://www.bar.org">
<xsl:template match="/">
  <html>
  <body>
  <h2>My File Checksums</h2>
    <table border="1">
      <tr bgcolor="#9acd32">
        <th>Name</th>
        <th>SHA1</th>
      </tr>
      <xsl:for-each select="catalog/foo:cd">
      <tr>
        <td><xsl:value-of select="name"/></td>
        <td><xsl:value-of select="SHA1"/></td>
      </tr>
      </xsl:for-each>
    </table>
  </body>
  </html>
</xsl:template>
</xsl:stylesheet>