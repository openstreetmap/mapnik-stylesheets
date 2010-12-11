<Style name="citywalls">
    <Rule>
      &maxscale_zoom14;
      &minscale_zoom14;
      <LineSymbolizer>
        <CssParameter name="stroke">grey</CssParameter>
        <CssParameter name="stroke-width">4</CssParameter>
        <CssParameter name="stroke-opacity">0.8</CssParameter>
        <CssParameter name="stroke-linejoin">round</CssParameter>
      </LineSymbolizer>
    </Rule>
    <Rule>
      &maxscale_zoom15;
      &minscale_zoom15;
      <LineSymbolizer>
        <CssParameter name="stroke">grey</CssParameter>
        <CssParameter name="stroke-width">6</CssParameter>
        <CssParameter name="stroke-opacity">0.8</CssParameter>
        <CssParameter name="stroke-linejoin">round</CssParameter>
      </LineSymbolizer>
    </Rule>
    <Rule>
      &maxscale_zoom16;
      &minscale_zoom18;
      <LineSymbolizer>
        <CssParameter name="stroke">grey</CssParameter>
        <CssParameter name="stroke-width">9</CssParameter>
        <CssParameter name="stroke-opacity">0.8</CssParameter>
        <CssParameter name="stroke-linejoin">round</CssParameter>
      </LineSymbolizer>
    </Rule>
</Style>
<Style name="castle_walls">
<Rule>
      &maxscale_zoom14;
      &minscale_zoom15;
      <LineSymbolizer>
        <CssParameter name="stroke">#999</CssParameter>
        <CssParameter name="stroke-width">1</CssParameter>
      </LineSymbolizer>
    </Rule>
    <Rule>
      &maxscale_zoom16;
      <LineSymbolizer>
        <CssParameter name="stroke">#888</CssParameter>
        <CssParameter name="stroke-width">2</CssParameter>
      </LineSymbolizer>
    </Rule>
</Style>
<Layer name="citywalls" status="on" srs="&osm2pgsql_projection;">
    <StyleName>citywalls</StyleName>
    <Datasource>
      <Parameter name="table">(select way from &prefix;_line where "historic"='citywalls') as citywalls</Parameter>
      &datasource-settings;
    </Datasource>
</Layer>
<Layer name="castle_walls" status="on" srs="&osm2pgsql_projection;">
    <StyleName>castle_walls</StyleName>
    <Datasource>
      <Parameter name="table">(select way from &prefix;_line where "historic"='castle_walls') as castle_walls</Parameter>
      &datasource-settings;
    </Datasource>
</Layer>
<Layer name="castle_walls" status="on" srs="&osm2pgsql_projection;">
    <StyleName>castle_walls</StyleName>
    <Datasource>
      <Parameter name="table">(select way from &prefix;_polygon where "historic"='castle_walls') as castle_walls</Parameter>
      &datasource-settings;
    </Datasource>
</Layer>



