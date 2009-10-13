<Style name="ferry-routes">
    <Rule>
      &maxscale_zoom7;
      &minscale_zoom10;
      <LineSymbolizer>
        <CssParameter name="stroke">#66f</CssParameter>
        <CssParameter name="stroke-width">0.4</CssParameter>
        <CssParameter name="stroke-dasharray">4,4</CssParameter>
      </LineSymbolizer>
    </Rule>
    <Rule>
      &maxscale_zoom11;
      <LineSymbolizer>
        <CssParameter name="stroke">#66f</CssParameter>
        <CssParameter name="stroke-width">0.8</CssParameter>
        <CssParameter name="stroke-dasharray">6,6</CssParameter>
      </LineSymbolizer>
    </Rule>
</Style>

<Layer name="ferry-routes" status="on" srs="&osm2pgsql_projection;">
    <StyleName>ferry-routes</StyleName>
    <Datasource>
      <Parameter name="table">
      (select way from &prefix;_line where route='ferry' ) as routes
      </Parameter>
      &datasource-settings;
    </Datasource>
</Layer>
