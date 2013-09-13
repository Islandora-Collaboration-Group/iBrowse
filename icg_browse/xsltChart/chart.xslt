<?xml version="1.0" encoding="UTF-8"?>
<!-- 
*****************************************************************************************************************
Title: XSLT Charts
Version: 1.02d
Copyright: http://www.prototec.co.nz
Website: http://www.xsltcharts.com
This is a commercial product, but there is a free use option.  See Website for details.
*****************************************************************************************************************
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<!-- Globals -->
	<xsl:variable name="fontAdjustment">1.2</xsl:variable>
	<xsl:variable name="fontWidthEstimate">1.8</xsl:variable>
	<xsl:variable name="spacing">5</xsl:variable>
	<xsl:variable name="epsilon">0.0001</xsl:variable>
	<xsl:variable name="tickWidth">
		<xsl:choose>
			<xsl:when test="//axes/@tick-width">
				<xsl:value-of select="//axes/@tick-width"/>
			</xsl:when>
			<xsl:otherwise>2.5</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:template match="/chart">
		<xsl:variable name="width">
			<xsl:choose>
				<xsl:when test="@width">
					<xsl:value-of select="@width"/>
				</xsl:when>
				<xsl:otherwise>300</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="height">
			<xsl:choose>
				<xsl:when test="@height">
					<xsl:value-of select="@height"/>
				</xsl:when>
				<xsl:otherwise>200</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

<!-- icg changed the width/height from 100% to 70% -->
		<svg width="70%" height="70%" viewBox="{concat('0 0 ',$width,' ',$height)}" version="1.1"
			xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
			<xsl:call-template name="copy">
				<xsl:with-param name="node" select="//before/*"/>
			</xsl:call-template>
			<title>
				<xsl:value-of select="title"/>
			</title>
			<xsl:if test="@background">
				<rect fill="{@background}" x="0" y="0" width="{$width}" height="{$height}"/>
			</xsl:if>
			<g stroke-width="0" font-family="sans-serif" fill="#000" stroke="#000">
				<xsl:if test="@font-family">
					<xsl:attribute name="font-family">
						<xsl:value-of select="@font-family"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:if test="@fill">
					<xsl:attribute name="fill">
						<xsl:value-of select="@fill"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:if test="@color">
					<xsl:attribute name="stroke">
						<xsl:value-of select="@color"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:variable name="depth">
					<xsl:choose>
						<xsl:when test="@depth">
							<xsl:value-of select="@depth"/>
						</xsl:when>
						<xsl:otherwise>0</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="titleSize">
					<xsl:choose>
						<xsl:when test="not(title)">0</xsl:when>
						<xsl:when test="title/@font-size">
							<xsl:value-of select="title/@font-size"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$height div 14"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="legendSize">
					<xsl:choose>
						<xsl:when test="data/@font-size">
							<xsl:value-of select="data/@font-size"/>
						</xsl:when>
						<xsl:when test="dataset/@font-size">
							<xsl:value-of select="dataset/@font-size"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$height div 17"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="xtitleSize">
					<xsl:choose>
						<xsl:when test="not(xtitle)">0</xsl:when>
						<xsl:when test="xtitle/@font-size">
							<xsl:value-of select="xtitle/@font-size"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$height div 17"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="ytitleSize">
					<xsl:choose>
						<xsl:when test="not(ytitle)">0</xsl:when>
						<xsl:when test="ytitle/@font-size">
							<xsl:value-of select="ytitle/@font-size"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$height div 17"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="labelSize">
					<xsl:choose>
						<xsl:when test="labels/@font-size">
							<xsl:value-of select="labels/@font-size"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:choose>
								<xsl:when test="@type != 'pie'">
									<xsl:value-of select="$height div 22"/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="$height div 17"/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<xsl:variable name="maxLegend">
					<xsl:call-template name="maxLegend"/>
				</xsl:variable>
				<xsl:variable name="legendWidth">
					<xsl:choose>
						<xsl:when test="$maxLegend &gt; 0">
							<xsl:value-of
								select="$maxLegend * $legendSize * $fontAdjustment div $fontWidthEstimate + $legendSize + 2*$spacing"
							/>
						</xsl:when>
						<!-- dangerous estimate -->
						<xsl:otherwise>
							<xsl:value-of select="$spacing"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:if test="title">
					<text font-size="{$titleSize}" x="{$width*.5}" y="{$titleSize}"
						text-anchor="middle">
						<xsl:for-each select="title/@*">
							<xsl:attribute name="{name()}">
								<xsl:value-of select="."/>
							</xsl:attribute>
						</xsl:for-each>
						<xsl:value-of select="title"/>
					</text>
				</xsl:if>
				<xsl:variable name="cols" select="count(//data)"/>
				<xsl:variable name="rows" select="count(//data[1]/value)"/>
				<xsl:variable name="stack"
					select="substring(/chart/@type,string-length(/chart/@type)-4) = 'stack'"/>

				<!-- Pie only variables -->
				<xsl:variable name="pa">
					<xsl:call-template name="root">
						<xsl:with-param name="value" select="$rows"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="pies_across" select="ceiling($pa)"/>
				<xsl:variable name="pies_down" select="ceiling($rows div $pies_across)"/>
				<xsl:variable name="pie_width"
					select="($width -$legendWidth) div $pies_across -$spacing"/>
				<xsl:variable name="pie_height"
					select="($height -$titleSize * $fontAdjustment -3*$spacing) div $pies_down"/>
				<xsl:variable name="pie_rx" select="$pie_width*.5"/>
				<xsl:variable name="pie_ry" select="$pie_height*.5"/>

				<!-- Axes only variables -->
				<xsl:variable name="omin">
					<xsl:choose>
						<xsl:when test="//value[not(//value &lt; .)] &gt; 0">0</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="//value[not(//value &lt; .)]"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="omax">
					<xsl:choose>
						<xsl:when test="$stack">
							<xsl:call-template name="maxSum"/>
						</xsl:when>
						<xsl:when test="//value[not(//value &gt; .)] &lt; 0">0</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="//value[not(//value &gt; .)]"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="step">
					<xsl:call-template name="stepSize">
						<xsl:with-param name="size" select="$omax -$omin"/>
					</xsl:call-template>
				</xsl:variable>
				<xsl:variable name="max" select="ceiling($omax div $step) * $step"/>
				<xsl:variable name="min" select="floor($omin div $step) * $step"/>
				<xsl:variable name="labelWidth">
					<xsl:choose>
						<xsl:when test="string-length($max) &gt; string-length($min)">
							<xsl:value-of select="string-length($max) * $labelSize div 2"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="string-length($min) * $labelSize div 2"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<xsl:variable name="range" select="$max - $min"/>
				<xsl:variable name="graphx"
					select="$xtitleSize * $fontAdjustment + $labelWidth + 3 * $tickWidth"/>
				<xsl:variable name="graphy"
					select="$titleSize * $fontAdjustment + 3 * $spacing + $depth"/>
				<xsl:variable name="graphw"
					select="$width - $graphx - 2 * $tickWidth - $depth - $legendWidth"/>
				<xsl:variable name="graphh"
					select="$height - $graphy - ($ytitleSize + $labelSize) * $fontAdjustment - 2*$spacing"/>
				<xsl:variable name="colWidth"
					select="($graphw - 2*$tickWidth - $depth*$rows) div ($rows * $cols + 2*$rows - 2)"/>

				<xsl:for-each select="//data">
					<xsl:variable name="col" select="position()"/>
					<xsl:variable name="fill">
						<!-- Get Fill Color -->
						<xsl:choose>
							<xsl:when test="@color">
								<xsl:value-of select="@color"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="range9">
									<xsl:choose>
										<xsl:when test="$cols &gt; 9">9</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select="$cols"/>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:variable>
								<xsl:variable name="hue"
									select="((($col -1) mod $range9) div $range9 div 3.0 + (($col -1) mod 3) div 3.0) * 0.85"/>
								<xsl:variable name="saturation"
									select="1.0 - (floor(($col -1) div $range9 * 0.5) mod 2) * 0.5 "/>
								<xsl:variable name="brightness"
									select="0.8 - floor(($col -1+$range9) div $range9 * 0.5) div (($cols+$range9) div $range9 * 0.5) * 0.4"/>
								<xsl:variable name="b" select="floor($brightness * 255 + 0.5)"/>
								<xsl:variable name="h" select="floor(($hue - floor($hue)) * 6.0)"/>
								<xsl:variable name="f" select="$h - floor($h)"/>
								<xsl:variable name="p"
									select="floor($brightness * (1.0 - $saturation) * 255 + 0.5)"/>
								<xsl:variable name="q"
									select="floor($brightness * (1.0 - $saturation * $f) * 255 + 0.5)"/>
								<xsl:variable name="t"
									select="floor($brightness * (1.0 - ($saturation * (1.0 - $f))) * 255 + 0.5)"/>
								<xsl:choose>
									<xsl:when test="$h = 0">rgb(<xsl:value-of select="$b"
											/>,<xsl:value-of select="$t"/>,<xsl:value-of select="$p"
										/>)</xsl:when>
									<xsl:when test="$h = 1">rgb(<xsl:value-of select="$q"
											/>,<xsl:value-of select="$b"/>,<xsl:value-of select="$p"
										/>)</xsl:when>
									<xsl:when test="$h = 2">rgb(<xsl:value-of select="$p"
											/>,<xsl:value-of select="$b"/>,<xsl:value-of select="$t"
										/>)</xsl:when>
									<xsl:when test="$h = 3">rgb(<xsl:value-of select="$p"
											/>,<xsl:value-of select="$q"/>,<xsl:value-of select="$b"
										/>)</xsl:when>
									<xsl:when test="$h = 4">rgb(<xsl:value-of select="$t"
											/>,<xsl:value-of select="$p"/>,<xsl:value-of select="$b"
										/>)</xsl:when>
									<xsl:when test="$h = 5">rgb(<xsl:value-of select="$b"
											/>,<xsl:value-of select="$p"/>,<xsl:value-of select="$q"
										/>)</xsl:when>
								</xsl:choose>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<xsl:for-each select="value">
						<xsl:variable name="row" select="position()"/>
						<xsl:variable name="total" select="sum(//value[position() = $row])"/>
						<xsl:variable name="title">
							<xsl:choose>
								<!-- hamilton removed the number of hits from the $title variable
								<xsl:when test="//data[$col]/@name"><xsl:value-of select="concat(//data[$col]/@name,': ',.)"/></xsl:when>
								-->
								<xsl:when test="//data[$col]/@name">
									<xsl:value-of select="//data[$col]/@name"/>
								</xsl:when>
								<xsl:otherwise>
						s			<xsl:value-of select="."/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:variable name="percent"
							select="concat($title,' (',format-number(. div $total, '0.00%'),')')"/>
						<xsl:choose>
							<xsl:when test="/chart/@type = 'pie'">
								<xsl:variable name="pieRow"
									select="floor((position()-1) div $pies_across)"/>
								<xsl:variable name="x"
									select="($width -$legendWidth) div $pies_across * ((position()-1) mod $pies_across) +$spacing"/>
								<xsl:variable name="y"
									select="$pie_height * $pieRow + ($titleSize+$labelSize) * $fontAdjustment+2*$spacing"/>
								<xsl:variable name="rx" select="$pie_width* 0.5"/>
								<xsl:variable name="ry"
									select="($pie_height -$labelSize*$fontAdjustment -$spacing - $depth) * 0.5"/>
								<xsl:if test="$col = 1">
									<text x="{$x}"
										y="{$y -$spacing -$labelSize*($fontAdjustment -1)}"
										font-size="{$labelSize}">
										<xsl:for-each select="//labels/@*">
											<xsl:attribute name="{name()}">
												<xsl:value-of select="."/>
											</xsl:attribute>
										</xsl:for-each>
										<xsl:for-each select="//label[$row]/@*">
											<xsl:attribute name="{name()}">
												<xsl:value-of select="."/>
											</xsl:attribute>
										</xsl:for-each>
										<xsl:value-of select="/chart/labels/label[$row]"/>
									</text>
								</xsl:if>
								<xsl:choose>
									<xsl:when test="$cols = 1">
										<path fill="{$fill}" title="{$percent}" stroke="none"
											d="{concat('M',$x,' ',$y+$ry,'a',$rx,' ',$ry,' 0 0 1 ',2*$rx,' 0l0 ',$depth,'a',$rx,' ',$ry,' 0 0 1 ',-2*$rx,' 0l0 ',$depth,'z')}"
										/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:variable name="deg">
											<xsl:choose>
												<xsl:when test="$col = 1">360</xsl:when>
												<xsl:otherwise>
												<xsl:value-of
												select="360 * (1-sum(//data[position() &lt;=$col -1]/value[position() = $row]) div $total)"
												/>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
										<xsl:variable name="c">
											<xsl:call-template name="sine">
												<xsl:with-param name="deg" select="$deg"/>
											</xsl:call-template>
										</xsl:variable>
										<xsl:variable name="s">
											<xsl:call-template name="sine">
												<xsl:with-param name="deg" select="-$deg - 90"/>
											</xsl:call-template>
										</xsl:variable>
										<xsl:variable name="deg2"
											select="360 * (1-sum(//data[position() &lt;=$col]/value[position() = $row]) div $total)"/>
										<xsl:variable name="c2">
											<xsl:call-template name="sine">
												<xsl:with-param name="deg" select="$deg2"/>
											</xsl:call-template>
										</xsl:variable>
										<xsl:variable name="s2">
											<xsl:call-template name="sine">
												<xsl:with-param name="deg" select="-$deg2 - 90"/>
											</xsl:call-template>
										</xsl:variable>
										<xsl:variable name="opt">
											<xsl:choose>
												<xsl:when test="$deg - $deg2 &lt; 180">0</xsl:when>
												<xsl:otherwise>1</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
										<path fill="{$fill}" title="{$percent}" stroke="none"
											d="{concat('M',$x+$rx,' ',$y+$ry,'L',$x+$rx+$rx*$c2,' ',$y+$ry+$ry*$s2,'A',$rx,' ',$ry,' 0 ',$opt,' 1 ',$x+$rx + $rx * $c,' ',$y+$ry +$ry*$s,'z')}"/>
										<xsl:if
											test="$depth &gt; 0 and $deg2 &lt; 270 and $deg &gt; 90">
											<xsl:variable name="c3">
												<xsl:choose>
												<xsl:when test="$deg2 &lt; 90">1</xsl:when>
												<xsl:otherwise>
												<xsl:value-of select="$c2"/>
												</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<xsl:variable name="c4">
												<xsl:choose>
												<xsl:when test="$deg &gt; 270">-1</xsl:when>
												<xsl:otherwise>
												<xsl:value-of select="$c"/>
												</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<xsl:variable name="s3">
												<xsl:choose>
												<xsl:when test="$deg2 &lt; 90">0</xsl:when>
												<xsl:otherwise>
												<xsl:value-of select="$s2"/>
												</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<xsl:variable name="s4">
												<xsl:choose>
												<xsl:when test="$deg &gt; 270">0</xsl:when>
												<xsl:otherwise>
												<xsl:value-of select="$s"/>
												</xsl:otherwise>
												</xsl:choose>
											</xsl:variable>
											<path fill="{$fill}" stroke="none"
												d="{concat('M',$x+$rx+$rx*$c3,' ',$y+$ry+$ry*$s3,'A',$rx,' ',$ry,' 0 ',$opt,' 1 ',$x+$rx+$rx*$c4,' ',$y+$ry+$ry*$s4,'l0 ',$depth,'A',$rx,' ',$ry,' 0 ',$opt,' 0 ',$x+$rx+$rx*$c3,' ',$y+$ry+$ry*$s3 +$depth,'z')}"/>
											<!-- opt asking for trouble -->
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:if test="$depth &gt; 0">
									<path fill="black" opacity="0.25" stroke="none"
										d="{concat('M',$x,' ',$y+$ry,'a',$rx,' ',$ry,' 0 0 0 ',2*$rx,' 0l0 ',$depth,'a',$rx,' ',$ry,' 0 0 1 ',-2*$rx,' 0z')}"
									/>
								</xsl:if>
							</xsl:when>
							<xsl:otherwise>
								<xsl:variable name="stackWidth" select="$cols * $colWidth"/>
								<xsl:variable name="x"
									select="$graphx + 2*$tickWidth + ($stackWidth+2*$colWidth) * ($row -1) + $stackWidth *.5 + $depth*($row -1)"/>
								<xsl:choose>
									<xsl:when test="/chart/@type = 'line'">
										<!-- Draw lines -->
										<xsl:variable name="y"
											select="$graphy + ($max - .) div $range * $graphh"/>
										<xsl:if test="$row &gt; 1">
											<xsl:variable name="x2"
												select="$x - $stackWidth - 2*$colWidth"/>
											<xsl:variable name="y2"
												select="$graphy + ($max - ../value[$row -1]) div $range * $graphh"/>
											<xsl:if test="$depth &gt; 0">
												<path fill="{$fill}" title="{$title}"
												d="{concat('M',$x2,' ',$y2,'L',$x,' ',$y,'l',$depth,' ',-$depth,'L',$x2+$depth,' ',$y2 -$depth,'z')}"/>
												<xsl:variable name="hypot">
												<xsl:call-template name="root">
												<xsl:with-param name="value"
												select="($y2 -$y)*($y2 -$y) + ($x2 -$x)*($x2 -$x)"
												/>
												</xsl:call-template>
												</xsl:variable>
												<path
												d="{concat('M',$x2,' ',$y2,'L',$x,' ',$y,'l',$depth,' ',-$depth,'L',$x2+$depth,' ',$y2 -$depth,'z')}">
												<xsl:variable name="opacity"
												select="1 - ($x -$x2) div $hypot"/>
												<xsl:attribute name="fill">black</xsl:attribute>
												<xsl:attribute name="opacity">
												<xsl:value-of select="$opacity"/>
												</xsl:attribute>
												</path>
											</xsl:if>
											<line x1="{$x2}" y1="{$y2}" x2="{$x}" y2="{$y}"
												stroke-width="1" stroke="{$fill}"/>
										</xsl:if>
										<circle r="{$tickWidth}" cx="{$x}" cy="{$y}" fill="{$fill}"
											title="{$title}"/>
									</xsl:when>
									<xsl:when test="$stack">
										<!-- Draw barstack -->

										<xsl:variable name="xpos" select="$x - $stackWidth*.5"/>
										<xsl:if test="$col = 1">
											<path fill="{$fill}" title="{$percent}"
												d="{concat('M',$xpos,' ',$graphy + ($max -sum(//data/value[$row])) div $range * $graphh,'l',$depth,' ',-$depth,' ',$stackWidth,' 0 ',-$depth,' ',$depth,'z')}"
											/>
										</xsl:if>
										<path fill="{$fill}" title="{$percent}"
											d="{concat('M',$xpos,' ',$graphy + ($max -sum(//data[position() &gt; $col]/value[$row])) div $range * $graphh,'l',$stackWidth,' 0 ',$depth,' ',-$depth,' 0 ',-. div $range * $graphh,' ',-$depth,' ',$depth,' ',-$stackWidth,' 0z')}"/>
										<xsl:if test="$depth &gt; 0 and $col = $cols">
											<path fill="white" opacity=".5"
												d="{concat('M',$xpos,' ',$graphy + ($max -sum(//data/value[$row])) div $range * $graphh,'l',$depth,' ',-$depth,' ',$stackWidth,' 0 ',-$depth,' ',$depth,'z')}"/>
											<path fill="black" opacity=".5"
												d="{concat('M',$xpos + $stackWidth,' ',$graphy + $max div $range * $graphh,'l',$depth,' ',-$depth,' 0 ',-sum(//data/value[$row]) div $range * $graphh,' ',-$depth,' ',$depth,'z')}"
											/>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<!-- Draw bars -->
										<xsl:variable name="top">
											<xsl:choose>
												<xsl:when test=". &lt; 0">1</xsl:when>
												<xsl:otherwise>0</xsl:otherwise>
											</xsl:choose>
										</xsl:variable>
										<xsl:variable name="xpos"
											select="$x - $stackWidth*.5 + $colWidth*($col -1)"/>
										<path fill="{$fill}" title="{$title}"
											d="{concat('M',$xpos,' ',$graphy + $max div $range * $graphh,'l',$depth*$top,' ', -$depth*$top,' ',$colWidth,' 0 ',$depth*(1 -$top),' ',-$depth*(1 -$top),' 0 ',-. div $range * $graphh,' ',-$depth*$top,' ',$depth*$top,' ',-$colWidth,' 0 ',-$depth*(1 -$top),' ',$depth*(1  -$top))}"/>
										<xsl:if test="$depth &gt; 0">
											<path fill="white" opacity=".5"
												d="{concat('M',$xpos,' ',$graphy + $max div $range * $graphh -(1-$top)*. div $range * $graphh,'l',$depth,' ',-$depth,' ',$colWidth,' 0 ',-$depth,' ',$depth,'z')}"/>
											<path fill="black" opacity=".5"
												d="{concat('M',$xpos + $colWidth,' ',$graphy + $max div $range * $graphh -(1-$top)*. div $range * $graphh,'l',$depth,' ',-$depth,' 0 ',-($top -0.5)*2*. div $range * $graphh,' ',-$depth,' ',$depth,'z')}"
											/>
										</xsl:if>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:if test="$col = $cols">
									<!-- Draw xAxis Labels & Ticks -->
									<xsl:variable name="ypos"
										select="$graphy+($graphh div $range * $max)"/>
									<line x1="{$x}" y1="{$ypos - $tickWidth}" x2="{$x}"
										y2="{$ypos + $tickWidth}" stroke-width="1" stroke="black">
										<xsl:for-each select="//axes/@*">
											<xsl:attribute name="{name()}">
												<xsl:value-of select="."/>
											</xsl:attribute>
										</xsl:for-each>
									</line>
									<text font-size="{$labelSize}" x="{$x}"
										y="{$ypos + $tickWidth + $labelSize}" text-anchor="middle">
										<xsl:for-each select="//labels/@*">
											<xsl:attribute name="{name()}">
												<xsl:value-of select="."/>
											</xsl:attribute>
										</xsl:for-each>
										<xsl:for-each select="//label[$row]/@*">
											<xsl:attribute name="{name()}">
												<xsl:value-of select="."/>
											</xsl:attribute>
										</xsl:for-each>
										<xsl:value-of select="/chart/labels/label[$row]"/>
									</text>
								</xsl:if>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:for-each>

					<xsl:variable name="yleg"
						select="((position() -1) * $legendSize + $titleSize) * $fontAdjustment + 2*$spacing"/>
					<g>

						<xsl:for-each select="//dataset/@*">
							<xsl:attribute name="{name()}">
								<xsl:value-of select="."/>
							</xsl:attribute>
						</xsl:for-each>
						<xsl:if test="$maxLegend &gt; 0">
							<text x="{$width -$legendWidth + $legendSize + 2*$spacing}"
								y="{$yleg + $legendSize div $fontAdjustment }"
								font-size="{$legendSize}">
								<xsl:for-each select="//data[$col]/@*">
									<xsl:choose>
										<xsl:when test="name() = 'name'"/>
										<xsl:when test="name() = 'color'"/>
										<xsl:otherwise>
											<xsl:attribute name="{name()}">
												<xsl:value-of select="."/>
											</xsl:attribute>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
								<xsl:value-of select="@name"/>
							</text>
							<rect x="{$width -$legendWidth + $spacing}" y="{$yleg}"
								width="{$legendSize}" height="{$legendSize}" fill="{$fill}"
								stroke-width="0"/>
						</xsl:if>
					</g>
				</xsl:for-each>

				<xsl:if test="not(/chart/@type = 'pie')">
					<!-- Draw Axes -->
					<xsl:if test="xtitle">
						<text font-size="{$xtitleSize}" x="{$graphw*.5 +$graphx}"
							y="{$height + (1- $fontAdjustment) * $xtitleSize - $spacing}"
							text-anchor="middle">
							<xsl:if test="xtitle/@color">
								<xsl:attribute name="fill">
									<xsl:value-of select="xtitle/@color"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:value-of select="xtitle"/>
						</text>
					</xsl:if>
					<xsl:if test="ytitle">
						<text transform="rotate(-90)" font-size="{$ytitleSize}"
							x="{-$graphy -0.5 * $graphh}" y="{$ytitleSize}" text-anchor="middle">
							<xsl:if test="ytitle/@color">
								<xsl:attribute name="fill">
									<xsl:value-of select="ytitle/@color"/>
								</xsl:attribute>
							</xsl:if>
							<xsl:value-of select="ytitle"/>
						</text>
					</xsl:if>
					<g stroke-width="1">
						<xsl:for-each select="//axes/@*">
							<xsl:attribute name="{name()}">
								<xsl:value-of select="."/>
							</xsl:attribute>
						</xsl:for-each>
						<line x1="{$graphx}" y1="{$graphy+($graphh div $range * $max)}"
							x2="{$graphx+$graphw + 1.5 * $tickWidth + $depth}"
							y2="{$graphy+($graphh div $range * $max)}"/>
						<line x1="{$graphx}" x2="{$graphx}">
							<xsl:attribute name="y1">
								<xsl:choose>
									<xsl:when test="$max &gt; 0">
										<xsl:value-of select="$graphy - 1.5 * $tickWidth - $depth"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$graphy"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<xsl:attribute name="y2">
								<xsl:choose>
									<xsl:when test="$min &lt; 0">
										<xsl:value-of select="$graphy+ $graphh + 1.5 * $tickWidth"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:value-of select="$graphy + $graphh"/>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
						</line>
					</g>
					<g>
						<xsl:for-each select="//axes/@*">
							<xsl:attribute name="{name()}">
								<xsl:value-of select="."/>
							</xsl:attribute>
						</xsl:for-each>
						<xsl:if test="$max &gt; 0">
							<path
								d="{concat('M',$graphx -$tickWidth,' ',$graphy -$tickWidth -$depth,'l',$tickWidth,' ',-2*$tickWidth,' ',$tickWidth,' ',2*$tickWidth)}"
							/>
						</xsl:if>
						<xsl:if test="$min &lt; 0">
							<path
								d="{concat('M',$graphx -$tickWidth,' ',$graphy + $graphh + $tickWidth,'l',$tickWidth,' ',2*$tickWidth,' ',$tickWidth,' ',-2*$tickWidth)}"
							/>
						</xsl:if>
						<path
							d="{concat('M',$graphx+$graphw+$tickWidth+$depth,' ',$graphy+$graphh*$max div $range - $tickWidth,'l',2*$tickWidth,' ',$tickWidth,' ',-2*$tickWidth,' ',$tickWidth)}"
						/>
					</g>
					<g font-size="{$labelSize}" stroke-width="1" text-anchor="end">
						<xsl:for-each select="//axes/@*">
							<xsl:attribute name="{name()}">
								<xsl:value-of select="."/>
							</xsl:attribute>
						</xsl:for-each>
						<xsl:call-template name="verticalTicks">
							<xsl:with-param name="x" select="$graphx - $tickWidth"/>
							<xsl:with-param name="yTextDelta" select="$labelSize div 3"/>
							<xsl:with-param name="yStart" select="$graphy+$graphh"/>
							<xsl:with-param name="yRange" select="$graphh"/>
							<xsl:with-param name="vStart" select="$min"/>
							<xsl:with-param name="vRange" select="$range"/>
							<xsl:with-param name="vStep" select="$step"/>
							<xsl:with-param name="pos" select="0"/>
						</xsl:call-template>
					</g>

				</xsl:if>
			</g>
			<xsl:call-template name="copy">
				<xsl:with-param name="node" select="//after/*"/>
			</xsl:call-template>
			<!-- Visible Credit -->
			<a xlink:href="http://www.xsltcharts.com" target="_top">
				<text font-size="{$height div 25}" fill="black" stroke="black"
					stroke-width="{$width div 150}" text-anchor="end" x="{$width -($width div 100)}"
					y="{$height - ($height div 210) }" font-family="sans-serif"
					>xsltCharts.com</text>
				<text font-size="{$height div 25}" fill="white" stroke-width="0" text-anchor="end"
					x="{$width -($width div 100)}" y="{$height - ($height div 210)}"
					font-family="sans-serif">xsltCharts.com</text>
			</a>
			<!-- /Visible Credit -->
		</svg>
	</xsl:template>

	<xsl:template name="verticalTicks" xmlns="http://www.w3.org/2000/svg">
		<xsl:param name="x"/>
		<xsl:param name="yTextDelta"/>
		<xsl:param name="yStart"/>
		<xsl:param name="yRange"/>
		<xsl:param name="vStart"/>
		<xsl:param name="vRange"/>
		<xsl:param name="vStep"/>
		<xsl:param name="pos"/>
		<xsl:variable name="y" select="($yStart - $yRange div ($vRange div $vStep) * $pos)"/>
		<line x1="{$x}" y1="{$y}" x2="{$x+2*$tickWidth}" y2="{$y}"/>
		<text x="{$x -$tickWidth}" y="{$y+$yTextDelta}" stroke-width="0">
			<xsl:for-each select="//labels/@*">
				<xsl:attribute name="{name()}">
					<xsl:value-of select="."/>
				</xsl:attribute>
			</xsl:for-each>
			<xsl:value-of select="$vStart + $vStep * $pos"/>
		</text>
		<xsl:if test="$pos * $vStep &lt; $vRange">
			<xsl:call-template name="verticalTicks">
				<xsl:with-param name="x" select="$x"/>
				<xsl:with-param name="yTextDelta" select="$yTextDelta"/>
				<xsl:with-param name="yStart" select="$yStart"/>
				<xsl:with-param name="yRange" select="$yRange"/>
				<xsl:with-param name="vStart" select="$vStart"/>
				<xsl:with-param name="vRange" select="$vRange"/>
				<xsl:with-param name="vStep" select="$vStep"/>
				<xsl:with-param name="pos" select="$pos + 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="stepSize">
		<!-- Graph Scaler -->
		<xsl:param name="size"/>
		<xsl:param name="start">1</xsl:param>
		<xsl:variable name="r" select="$size div $start"/>
		<xsl:choose>
			<xsl:when test="$r &gt; 10 or $r &lt; -10">
				<xsl:call-template name="stepSize">
					<xsl:with-param name="size" select="$size"/>
					<xsl:with-param name="start" select="$start * 10"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$r &lt; -1 and $r &gt; 1">
				<xsl:call-template name="stepSize">
					<xsl:with-param name="size" select="$size"/>
					<xsl:with-param name="start" select="$start div 10"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$r &lt; 2">
						<xsl:value-of select="$start div 2"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$start"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="copy">
		<xsl:param name="node"/>
		<xsl:for-each select="$node">
			<xsl:element name="{name()}" namespace="http://www.w3.org/2000/svg"
				xmlns:xlink="http://www.w3.org/1999/xlink">
				<xsl:for-each select="$node/@*">
					<xsl:attribute name="{name()}">
						<xsl:value-of select="."/>
					</xsl:attribute>
				</xsl:for-each>
				<xsl:for-each select="$node/*">
					<xsl:call-template name="copy">
						<xsl:with-param name="node" select="."/>
					</xsl:call-template>
				</xsl:for-each>
				<xsl:if test=".">
					<xsl:value-of select="."/>
				</xsl:if>
			</xsl:element>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="root">
		<xsl:param name="value"/>
		<xsl:param name="result">1</xsl:param>
		<xsl:variable name="res" select="($result + $value div $result) div 2"/>
		<xsl:choose>
			<xsl:when test="$res &lt; $result + $epsilon and $res &gt; $result - $epsilon">
				<xsl:value-of select="$result"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="root">
					<xsl:with-param name="value" select="$value"/>
					<xsl:with-param name="result" select="$res"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="sine">
		<!-- deg or rad -->
		<xsl:param name="deg"/>
		<xsl:param name="rad">
			<xsl:value-of select="$deg div 180 * 3.14159265358979323846"/>
		</xsl:param>
		<xsl:param name="ans">
			<xsl:value-of select="$rad"/>
		</xsl:param>
		<xsl:param name="loc">1</xsl:param>
		<xsl:param name="fract">
			<xsl:value-of select="$rad"/>
		</xsl:param>
		<xsl:variable name="fract2"
			select="-1 * $fract * $rad * $rad div ($loc *2 * ($loc * 2 + 1))"/>
		<xsl:choose>
			<!-- Exit when at end of precision -->
			<xsl:when test="$fract2 &lt; $epsilon and $fract2 &gt; -$epsilon">
				<xsl:value-of select="$ans"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="sine">
					<xsl:with-param name="rad" select="$rad"/>
					<xsl:with-param name="ans" select="$ans + $fract2"/>
					<xsl:with-param name="loc" select="$loc+1"/>
					<xsl:with-param name="fract" select="$fract2"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="maxLegend">
		<xsl:param name="loc">1</xsl:param>
		<xsl:param name="min">0</xsl:param>
		<xsl:variable name="current" select="string-length(//data[$loc]/@name)"/>
		<xsl:variable name="max">
			<xsl:choose>
				<xsl:when test="$min &lt; $current">
					<xsl:value-of select="$current"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$min"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$loc = count(//data)">
				<xsl:value-of select="$max"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="maxLegend">
					<xsl:with-param name="min" select="$max"/>
					<xsl:with-param name="loc" select="$loc + 1"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="maxSum">
		<xsl:param name="loc">1</xsl:param>
		<xsl:param name="min">0</xsl:param>
		<xsl:variable name="current" select="sum(//data/value[position() = $loc])"/>
		<xsl:variable name="max">
			<xsl:choose>
				<xsl:when test="$min &lt; $current">
					<xsl:value-of select="$current"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$min"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="$loc = count(//data/value)">
				<xsl:value-of select="$max"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="maxSum">
					<xsl:with-param name="min" select="$max"/>
					<xsl:with-param name="loc" select="$loc + 1"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
