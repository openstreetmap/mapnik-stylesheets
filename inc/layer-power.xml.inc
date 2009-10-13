<Style name="power">
    <Rule>
      &maxscale_zoom14;
      &minscale_zoom15;
      <LineSymbolizer>
        <CssParameter name="stroke">#777</CssParameter>
        <CssParameter name="stroke-width">1</CssParameter>
      </LineSymbolizer>
    </Rule>
    <Rule>
      &maxscale_zoom16;
      <LineSymbolizer>
        <CssParameter name="stroke">#777</CssParameter>
        <CssParameter name="stroke-width">1.5</CssParameter>
      </LineSymbolizer>
    </Rule>
</Style>
<Style name="power_towers">
    <Rule>
      &maxscale_zoom14;
      <PointSymbolizer file="&symbols;/power_tower.png" type="png" width="7" height="7" allow_overlap="false"/>
    </Rule>
</Style>

<Layer name="power" status="on" srs="&osm2pgsql_projection;">
    <StyleName>power</StyleName>
    <Datasource>
      <Parameter name="table">(select way from &prefix;_line where "power"='line') as power</Parameter>
      &datasource-settings;
    </Datasource>
</Layer>
<Layer name="power_towers" status="on" srs="&osm2pgsql_projection;">
     <StyleName>power_towers</StyleName>
    <Datasource>
      <Parameter name="table">(select way from &prefix;_point where power='tower') as power_towers</Parameter>
      &datasource-settings;
    </Datasource>
</Layer>
