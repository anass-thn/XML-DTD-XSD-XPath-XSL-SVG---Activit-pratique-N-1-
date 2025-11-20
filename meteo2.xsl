<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns="http://www.w3.org/2000/svg">
    
    <xsl:output method="xml" indent="yes" media-type="image/svg+xml"/>
    
    <xsl:template match="/meteo">
        <!-- Création de la zone de dessin SVG -->
        <svg width="1000" height="600" viewBox="0 0 1000 600" style="background-color: #f9f9f9; font-family: Arial, sans-serif;">
            
            <!-- Titre -->
            <text x="500" y="40" font-size="24" text-anchor="middle" fill="#333">Météo - Histogramme Animé</text>
            
            <!-- Définition des axes -->
            <line x1="50" y1="500" x2="950" y2="500" stroke="#333" stroke-width="2" />
            
            <!-- Boucle sur chaque mesure (chaque date) -->
            <xsl:for-each select="mesure[@date='2024-10-26']">
                <xsl:variable name="datePosition" select="position() - 1"/>
                <xsl:variable name="xOffset" select="$datePosition * 450 + 50"/>
                
                <!-- Groupe pour une date -->
                <g transform="translate({$xOffset}, 0)">
                    
                    <!-- Label de la date -->
                    <text x="200" y="600" font-size="18" text-anchor="middle" fill="#555" font-weight="bold">
                        <xsl:value-of select="@date"/>
                    </text>
                    
                    <!-- Boucle sur chaque ville -->
                    <xsl:for-each select="ville">
                        <xsl:variable name="pos" select="position() - 1"/>
                        <xsl:variable name="barWidth" select="30"/>
                        <xsl:variable name="gap" select="15"/>
                        <xsl:variable name="x" select="$pos * ($barWidth + $gap) + 20"/>
                        
                        <!-- Hauteur de la barre (échelle : x10 pour la visibilité) -->
                        <xsl:variable name="height" select="@temperature * 10"/>
                        <xsl:variable name="y" select="500 - $height"/>
                        
                        <!-- Couleur basée sur la température (froid -> chaud) -->
                        <xsl:variable name="color">
                            <xsl:choose>
                                <xsl:when test="@temperature &gt; 35">#ff4d4d</xsl:when> <!-- Rouge pour chaud -->
                                <xsl:when test="@temperature &gt; 25">#ffad33</xsl:when> <!-- Orange pour moyen -->
                                <xsl:otherwise>#4da6ff</xsl:otherwise> <!-- Bleu pour frais -->
                            </xsl:choose>
                        </xsl:variable>
                        
                        <!-- Barre avec animation -->
                        <rect x="{$x}" y="500" width="{$barWidth}" height="0" fill="{$color}" rx="2">
                            <title><xsl:value-of select="@nom"/> : <xsl:value-of select="@temperature"/>°C</title>
                            <!-- Animation de la hauteur -->
                            <animate attributeName="height" from="0" to="{$height}" dur="1s" fill="freeze" begin="0.2s"/>
                            <!-- Animation de la position Y (pour que la barre grandisse vers le haut) -->
                            <animate attributeName="y" from="500" to="{$y}" dur="1s" fill="freeze" begin="0.2s"/>
                        </rect>
                        
                        <!-- Température au-dessus de la barre -->
                        <text x="{$x + $barWidth div 2}" y="{$y - 5}" font-size="10" text-anchor="middle" fill="#000" opacity="0">
                            <xsl:value-of select="@temperature"/>
                            <animate attributeName="opacity" from="0" to="1" dur="0.5s" fill="freeze" begin="1s"/>
                            <animate attributeName="y" from="500" to="{$y - 5}" dur="1s" fill="freeze" begin="0.2s"/>
                        </text>
                        
                        <!-- Nom de la ville (rotation pour lisibilité) -->
                        <text x="{$x + $barWidth div 2}" y="515" font-size="10" text-anchor="end" transform="rotate(-45, {$x + $barWidth div 2}, 515)">
                            <xsl:value-of select="@nom"/>
                        </text>
                    </xsl:for-each>
                </g>
            </xsl:for-each>
        </svg>
    </xsl:template>
</xsl:stylesheet>