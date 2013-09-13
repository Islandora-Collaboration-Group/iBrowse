<xsl:stylesheet xmlns:s="http://www.w3.org/2001/sw/DataAccess/rf1/result"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

	<xsl:import href="icg_header.xsl"/>
	<xsl:output method="html"/>

	<xsl:param name="myType"/>
	<xsl:param name="myTitle"/>
	<xsl:param name="myNotes"/>
	<xsl:param name="myLabel"/>
	<xsl:param name="myCount"/>
	<xsl:param name="myServer"/>

	<xsl:key name="attrByVal" match="//@*" use="."/>

	<xsl:template match="/">
		<xsl:apply-imports/>

		<div id="icg_instructions">
			<h3>
				<xsl:value-of select="$myTitle"/>
			</h3>
			<p>Description: <xsl:value-of select="$myNotes"/></p>
			<p>Instructions: <xsl:value-of select="$myCount"/></p>
		</div>

		<div id="icg_content">

			<div class="icg_headerRow">
				<p class="col_1000">
					<xsl:text>Relationships</xsl:text>
				</p>
			</div>

			<div id="icg_table">
				<ul>
					<xsl:apply-templates select="//@*"/>
				</ul>
			</div>

			<div class="icg_headerRow">
				<xsl:text>&#160;</xsl:text>
			</div>

			<div id="icg_footer">
				<p>XSLT: icg_relations_islandora.xsl<br/>CSS: icg_results.css</p>
			</div>

		</div>

	</xsl:template>

	<xsl:template match="//s:relation/@*[generate-id()=generate-id(key('attrByVal', .)[1])]">
		<xsl:variable name="icg_term">
			<xsl:value-of select="."/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="contains(.,'islandora')">
				<li>
					<hr/>
					<p class="col_1000">
						<xsl:choose>
							<xsl:when test="contains($icg_term,'#')">
								<xsl:variable name="icg_term_url">
									<xsl:value-of select="substring-before($icg_term,'#')"/>
									<xsl:text>%23</xsl:text>
									<xsl:value-of select="substring-after($icg_term,'#')"/>
								</xsl:variable>
								<xsl:choose>
									<xsl:when
										test="contains($icg_term, 'ownerID') or contains($icg_term, 'state') or contains($icg_term, 'label') or contains($icg_term, 'createdDate')">
										<a
											href="/sites/all/modules/custom/includes/icg_make_query.php?icg_stype=properties&amp;icg_sterm={$icg_term_url}&amp;submit=Submit">
											<xsl:value-of select="$icg_term"/>
										</a>
									</xsl:when>
									<xsl:otherwise>
										<a
											href="/sites/all/modules/custom/includes/icg_make_query.php?icg_stype=relations_inc&amp;icg_sterm={$icg_term_url}&amp;submit=Submit">
											<xsl:value-of select="$icg_term"/>
										</a>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="myTypeInc">
									<xsl:choose>
										<xsl:when test="contains($icg_term, 'elements')">
											<xsl:text>properties</xsl:text>
										</xsl:when>
										<xsl:otherwise>find_relationship</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<a
									href="/sites/all/modules/custom/includes/icg_make_query.php?icg_stype={$myTypeInc}&amp;icg_sterm={$icg_term}&amp;submit=Submit">
									<xsl:value-of select="$icg_term"/>
								</a>
							</xsl:otherwise>
						</xsl:choose>
					</p>
				</li>
			</xsl:when>
			<xsl:otherwise>SOMETHING BAD HAPPENED</xsl:otherwise>
		</xsl:choose>

	</xsl:template>

	<xsl:template match="@*"/>

</xsl:stylesheet>
