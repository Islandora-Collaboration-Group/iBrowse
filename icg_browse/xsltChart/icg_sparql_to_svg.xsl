<xsl:stylesheet xmlns:s="http://www.w3.org/2001/sw/DataAccess/rf1/result"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:output method="xml"/>

	<xsl:param name="myType"/>
	<xsl:param name="myTitle"/>
	<xsl:param name="myTerm"/>

	<xsl:template match="/">
		<xsl:apply-imports/>

		<chart type="bar">
			<title>iBrowse Chart</title>
			<labels>
				<xsl:element name="label">
					<xsl:value-of select="$myTitle"/>
				</xsl:element>
			</labels>

			<xsl:for-each select="/s:sparql/s:results/s:result">
				<xsl:sort select="s:k0" data-type="number" order="descending"/>
				<xsl:choose>
					<xsl:when test="contains(s:target, $myTerm) or contains(s:target/@url, $myTerm)">
						<xsl:choose>
							<xsl:when test="s:target != ''">
								<data>
									<xsl:attribute name="name">
										<xsl:choose>
											<xsl:when test="contains(s:target, '.')">
												<xsl:value-of
												select="substring-after(substring-after(substring-after(s:target, '.'), '.'), '.')"
												/> (<xsl:value-of select="s:k0"/>) </xsl:when>
											<xsl:otherwise>
												<xsl:value-of
												select="substring-after(s:target, '/')"/>
												<xsl:text> (</xsl:text>
												<xsl:value-of select="s:k0"/>
												<xsl:text>)</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
									<xsl:element name="value">
										<xsl:value-of select="s:k0"/>
									</xsl:element>
								</data>
							</xsl:when>
							<xsl:when test="s:target/@url != ''">
								<data>
									<xsl:attribute name="name">
										<xsl:choose>
											<xsl:when test="contains(s:target/@url, '.')">
												<xsl:value-of
												select="substring-after(substring-after(substring-after(s:target/@url, '.'), '.'), '.')"/>
												<xsl:text> (</xsl:text>
												<xsl:value-of select="s:k0"/>
												<xsl:text>)</xsl:text>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of
												select="substring-after(s:target/@url, '/')"/></xsl:otherwise>
										</xsl:choose>
									</xsl:attribute>
									<xsl:element name="value">
										<xsl:value-of select="s:k0"/>
									</xsl:element>
								</data>
							</xsl:when>
							<xsl:otherwise> Target =<xsl:value-of select="s:target"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise/>
				</xsl:choose>
			</xsl:for-each>
		</chart>
	</xsl:template>

</xsl:stylesheet>
