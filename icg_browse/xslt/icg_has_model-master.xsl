<xsl:stylesheet xmlns:s="http://www.w3.org/2001/sw/DataAccess/rf1/result"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
	xmlns:fn="http://www.w3.org/2005/xpath-functions">

	<xsl:import href="icg_header.xsl"/>
	<xsl:output method="html"/>

	<xsl:param name="myType"/>
	<xsl:param name="myTitle"/>
	<xsl:param name="myTerm"/>
	<xsl:param name="myNotes"/>
	<xsl:param name="myCount"/>
	<xsl:param name="myServer"/>

	<xsl:template match="/">
		<xsl:apply-imports/>

		<div id="icg_instructions">
			<xsl:if test="$myTitle">
				<h3>
					<xsl:value-of select="$myTitle"/>
				</h3>
			</xsl:if>
			<xsl:if test="$myTerm">
				<div>
					<p>Full Form: &lt;<xsl:value-of select="$myTerm"/>&gt;</p>
				</div>
			</xsl:if>
			<xsl:if test="$myNotes">
				<div id="icg_notes">
					<p>
						<xsl:value-of select="$myNotes" disable-output-escaping="yes"/>
					</p>
				</div>
			</xsl:if>
			<xsl:if test="$myCount">
				<div>
					<p>
						<xsl:value-of select="$myCount" disable-output-escaping="yes"/>
					</p>
				</div>
			</xsl:if>
		</div>

		<div id="icg_content">

			<div class="icg_headerRow">
				<p class="col_100 count">
					<xsl:text>Instances</xsl:text>
				</p>
				<p class="col_400">
					<xsl:text>Content Model Name (dc:title)</xsl:text>
				</p>
				<p class="col_400">
					<xsl:text>Content Model PID</xsl:text>
				</p>
			</div>

			<div id="icg_table">

				<ul>
					<xsl:for-each select="/s:sparql/s:results/s:result">
						<xsl:sort select="s:k0" data-type="number" order="descending"/>
						<xsl:variable name="pid">
							<!-- strip 'info:fedora/' from string -->
							<xsl:value-of select="substring-after(s:target/@uri, '/')"/>
						</xsl:variable>
						<li>
							<hr/>
							<p class="col_100 count">
								<a
									href="/sites/all/modules/custom/includes/icg_make_query.php?icg_stype=hasModel_inc&amp;icg_sterm=info:fedora/fedora-system:def/model%23hasModel&amp;icg_starget={$pid}&amp;submit=Submit">
									<xsl:value-of select="format-number(s:k0, '###,###')"/>
								</a>
							</p>
							<p class="col_400">
								<xsl:value-of select="s:title"/>
							</p>
							<p class="col_400">
								<a>
									<xsl:attribute name="href">
										<xsl:value-of select="$myServer"/>
										<xsl:text>/fedora/objects/</xsl:text>
										<xsl:value-of select="$pid"/>
									</xsl:attribute>
									<xsl:value-of select="substring-after(s:target/@uri, '/')"/>
								</a>
							</p>
						</li>
					</xsl:for-each>
				</ul>
			</div>

			<div class="icg_headerRow">
				<p class="col_100 count">
					<xsl:value-of select="format-number(sum(//s:k0), '###,###')"/>
				</p>
				<p class="col_400 count">
					<xsl:text>&#160;</xsl:text>
				</p>
				<p class="col_400">
					<xsl:text>&#160;</xsl:text>
				</p>
			</div>

			<div id="icg_footer">
				<p>XSLT: icg_has_model.xsl<br/>CSS: icg_results.css</p>
			</div>

		</div>

	</xsl:template>

</xsl:stylesheet>
