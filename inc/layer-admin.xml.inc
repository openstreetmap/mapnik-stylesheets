<Style name="admin">
    <Rule>
      <Filter>[admin_level]='2' or [admin_level]='3'</Filter>
      &maxscale_zoom2;
      &minscale_zoom6;
      <LineSymbolizer>
        <CssParameter name="stroke">purple</CssParameter>
        <CssParameter name="stroke-width">0.6</CssParameter>
        <CssParameter name="stroke-opacity">0.2</CssParameter>
      </LineSymbolizer>
    </Rule>
    <Rule>
      <Filter>[admin_level]='2' or [admin_level]='3'</Filter>
      &maxscale_zoom7;
      &minscale_zoom9;
      <LineSymbolizer>
        <CssParameter name="stroke">purple</CssParameter>
        <CssParameter name="stroke-width">2</CssParameter>
        <CssParameter name="stroke-opacity">0.2</CssParameter>
      </LineSymbolizer>
    </Rule>
   <Rule>
      <Filter>[admin_level]='2'</Filter>
      &maxscale_zoom10;
      <LineSymbolizer>
        <CssParameter name="stroke">purple</CssParameter>
        <CssParameter name="stroke-width">6</CssParameter>
        <CssParameter name="stroke-opacity">0.1</CssParameter>
      </LineSymbolizer>
    </Rule>
    <Rule>
      <Filter>[admin_level]='3'</Filter>
      &maxscale_zoom10;
      <LineSymbolizer>
        <CssParameter name="stroke">purple</CssParameter>
        <CssParameter name="stroke-width">5</CssParameter>
        <CssParameter name="stroke-dasharray">4,2</CssParameter>
        <CssParameter name="stroke-opacity">0.1</CssParameter>
      </LineSymbolizer>
    </Rule>
    <Rule>
      <Filter>[admin_level]='4'</Filter>
      &maxscale_zoom4;
      &minscale_zoom6;
      <LineSymbolizer>
        <CssParameter name="stroke">purple</CssParameter>
        <CssParameter name="stroke-width">0.6</CssParameter>
        <CssParameter name="stroke-dasharray">4,3</CssParameter>
        <CssParameter name="stroke-opacity">0.2</CssParameter>
      </LineSymbolizer>
    </Rule>
    <Rule>
      <Filter>[admin_level]='4'</Filter>
      &maxscale_zoom7;
      &minscale_zoom10;
      <LineSymbolizer>
        <CssParameter name="stroke">purple</CssParameter>
        <CssParameter name="stroke-width">1</CssParameter>
        <CssParameter name="stroke-dasharray">4,3</CssParameter>
        <CssParameter name="stroke-opacity">0.2</CssParameter>
      </LineSymbolizer>
    </Rule>
    <Rule>
      <Filter>[admin_level]='4'</Filter>
      &maxscale_zoom11;
      <LineSymbolizer>
        <CssParameter name="stroke">purple</CssParameter>
        <CssParameter name="stroke-width">3</CssParameter>
        <CssParameter name="stroke-dasharray">4,3</CssParameter>
        <CssParameter name="stroke-opacity">0.2</CssParameter>
      </LineSymbolizer>
    </Rule>
    <Rule>
      <Filter>[admin_level]='5'</Filter>
      &maxscale_zoom11;
      <LineSymbolizer>
        <CssParameter name="stroke">purple</CssParameter>
        <CssParameter name="stroke-width">2</CssParameter>
        <CssParameter name="stroke-dasharray">6,3,2,3,2,3</CssParameter>
        <CssParameter name="stroke-opacity">0.3</CssParameter>
      </LineSymbolizer>
    </Rule>
    <Rule>
      <Filter>[admin_level]='6'</Filter>
      &maxscale_zoom11;
      <LineSymbolizer>
        <CssParameter name="stroke">purple</CssParameter>
        <CssParameter name="stroke-width">2</CssParameter>
        <CssParameter name="stroke-dasharray">6,3,2,3</CssParameter>
        <CssParameter name="stroke-opacity">0.3</CssParameter>
      </LineSymbolizer>
    </Rule>
    <Rule>
      <Filter>[admin_level]='8' or [admin_level]='7'</Filter>
      &maxscale_zoom12;
      <LineSymbolizer>
        <CssParameter name="stroke">purple</CssParameter>
        <CssParameter name="stroke-width">1.5</CssParameter>
        <CssParameter name="stroke-dasharray">5,2</CssParameter>
        <CssParameter name="stroke-opacity">0.3</CssParameter>
      </LineSymbolizer>
    </Rule>
    <Rule>
      <Filter>[admin_level]='10' or [admin_level]='9'</Filter>
      &maxscale_zoom13;
      <LineSymbolizer>
        <CssParameter name="stroke">purple</CssParameter>
        <CssParameter name="stroke-width">2</CssParameter>
        <CssParameter name="stroke-dasharray">2,3</CssParameter>
        <CssParameter name="stroke-opacity">0.3</CssParameter>
      </LineSymbolizer>
    </Rule>
   <Rule>
      <Filter>not [admin_level] &lt;&gt;''</Filter>
      &maxscale_zoom9;
      &minscale_zoom11;
      <LineSymbolizer>
        <CssParameter name="stroke">purple</CssParameter>
        <CssParameter name="stroke-width">1</CssParameter>
        <CssParameter name="stroke-opacity">0.2</CssParameter>
      </LineSymbolizer>
    </Rule>
</Style>

<Layer name="admin" status="on" srs="&osm2pgsql_projection;">
    <StyleName>admin</StyleName>
    <Datasource>
      <Parameter name="table">
      (select way,admin_level from &prefix;_roads where "boundary"='administrative') as admin</Parameter>
      &datasource-settings;
    </Datasource>
</Layer>
