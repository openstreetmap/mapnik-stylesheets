<Style name="piers-area">
    <Rule>
      &maxscale_zoom12;
      <PolygonSymbolizer>
        <CssParameter name="fill">#f2efe9</CssParameter>
      </PolygonSymbolizer>
    </Rule>
</Style>
<Style name="piers">
    <Rule>
      &maxscale_zoom11;
      &minscale_zoom12;
      <LineSymbolizer>
        <CssParameter name="stroke">#f2efe9</CssParameter>
        <CssParameter name="stroke-width">2</CssParameter>
      </LineSymbolizer>
    </Rule>
    <Rule>
      &maxscale_zoom13;
      &minscale_zoom14;
      <LineSymbolizer>
        <CssParameter name="stroke">#f2efe9</CssParameter>
        <CssParameter name="stroke-width">4</CssParameter>
      </LineSymbolizer>
    </Rule>
    <Rule>
      &maxscale_zoom15;
      &minscale_zoom18;
      <LineSymbolizer>
        <CssParameter name="stroke">#f2efe9</CssParameter>
        <CssParameter name="stroke-width">7</CssParameter>
      </LineSymbolizer>
    </Rule>
</Style>

<Layer name="piers-area" status="on" srs="&osm2pgsql_projection;">
    <StyleName>piers-area</StyleName>
    <Datasource>
      <Parameter name="table">
      (select way from &prefix;_polygon where man_made='pier') as piers
      </Parameter>
      &datasource-settings;
    </Datasource>
</Layer>
<Layer name="piers" status="on" srs="&osm2pgsql_projection;">
     <StyleName>piers</StyleName>
     <Datasource>
      <Parameter name="table">
      (select way from &prefix;_line where man_made='pier') as piers
      </Parameter>
      &datasource-settings;
    </Datasource>
</Layer>

