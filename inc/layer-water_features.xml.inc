<Style name="dam">
    <Rule>
      &maxscale_zoom13;
      &minscale_zoom18;
      <LineSymbolizer>
        <CssParameter name="stroke">#444</CssParameter>
        <CssParameter name="stroke-width">2</CssParameter>
        <CssParameter name="stroke-linejoin">round</CssParameter>
        <CssParameter name="stroke-linecap">round</CssParameter>
      </LineSymbolizer>
    </Rule>
    <Rule>
      &maxscale_zoom15;
      <TextSymbolizer name="name" fontset_name="book-fonts" size="8" fill="#222" halo_radius="1"/>
    </Rule>
</Style>
<Style name="marinas-area">
    <Rule>
      &maxscale_zoom14;
      &minscale_zoom15;
      <LineSymbolizer>
        <CssParameter name="stroke">blue</CssParameter>
        <CssParameter name="stroke-width">1</CssParameter>
        <CssParameter name="stroke-dasharray">6,2</CssParameter>
        <CssParameter name="stroke-opacity">0.5</CssParameter>
      </LineSymbolizer>
    </Rule>
    <Rule>
      &maxscale_zoom16;
      <LineSymbolizer>
        <CssParameter name="stroke">blue</CssParameter>
        <CssParameter name="stroke-width">2</CssParameter>
        <CssParameter name="stroke-dasharray">6,2</CssParameter>
        <CssParameter name="stroke-opacity">0.5</CssParameter>
      </LineSymbolizer>
    </Rule>
</Style>
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
      <Filter>[man_made]='breakwater' or [man_made]='groyne'</Filter>
      <LineSymbolizer>
        <CssParameter name="stroke">#aaa</CssParameter>
        <CssParameter name="stroke-width">1</CssParameter>
      </LineSymbolizer>
    </Rule>
    <Rule>
      &maxscale_zoom11;
      &minscale_zoom12;
      <Filter>[man_made]='pier'</Filter>
      <LineSymbolizer>
        <CssParameter name="stroke">#f2efe9</CssParameter>
        <CssParameter name="stroke-width">1.5</CssParameter>
      </LineSymbolizer>
    </Rule>
    <Rule>
      &maxscale_zoom13;
      &minscale_zoom15;
      <Filter>[man_made]='breakwater' or [man_made]='groyne'</Filter>
      <LineSymbolizer>
        <CssParameter name="stroke">#aaa</CssParameter>
        <CssParameter name="stroke-width">2</CssParameter>
      </LineSymbolizer>
    </Rule>
    <Rule>
      &maxscale_zoom13;
      &minscale_zoom15;
      <Filter>[man_made]='pier'</Filter>
      <LineSymbolizer>
        <CssParameter name="stroke">#f2efe9</CssParameter>
        <CssParameter name="stroke-width">3</CssParameter>
      </LineSymbolizer>
    </Rule>
    <Rule>
      &maxscale_zoom16;
      &minscale_zoom18;
      <Filter>[man_made]='breakwater' or [man_made]='groyne'</Filter>
      <LineSymbolizer>
        <CssParameter name="stroke">#aaa</CssParameter>
        <CssParameter name="stroke-width">4</CssParameter>
      </LineSymbolizer>
    </Rule>
    <Rule>
      &maxscale_zoom16;
      &minscale_zoom18;
      <Filter>[man_made]='pier'</Filter>
      <LineSymbolizer>
        <CssParameter name="stroke">#f2efe9</CssParameter>
        <CssParameter name="stroke-width">7</CssParameter>
      </LineSymbolizer>
    </Rule>
</Style>
<Style name="locks">
<Rule>
      &maxscale_zoom17;
      &minscale_zoom18;
      <Filter>[waterway]='lock_gate'</Filter>
      <PointSymbolizer file="&symbols;/lock_gate.png" />
</Rule>
</Style>
<Layer name="dam" status="on" srs="&osm2pgsql_projection;">
    <StyleName>dam</StyleName>
    <Datasource>
      <Parameter name="table">
      (select way,name from &prefix;_line where waterway='dam') as dam</Parameter>
      &datasource-settings;
    </Datasource>
</Layer>
<Layer name="marinas-area" status="on" srs="&osm2pgsql_projection;">
    <StyleName>marinas-area</StyleName>
    <Datasource>
      <Parameter name="table">
      (select way from &prefix;_polygon where leisure ='marina') as marinas
      </Parameter>
      &datasource-settings;
    </Datasource>
</Layer>
<Layer name="piers-area" status="on" srs="&osm2pgsql_projection;">
    <StyleName>piers-area</StyleName>
    <Datasource>
      <Parameter name="table">
      (select way,man_made from &prefix;_polygon where man_made in ('pier','breakwater','groyne')) as piers
      </Parameter>
      &datasource-settings;
    </Datasource>
</Layer>
<Layer name="piers" status="on" srs="&osm2pgsql_projection;">
     <StyleName>piers</StyleName>
     <Datasource>
      <Parameter name="table">
      (select way,man_made from &prefix;_line where man_made in ('pier','breakwater','groyne')) as piers
      </Parameter>
      &datasource-settings;
    </Datasource>
</Layer>
<Layer name="locks" status="on" srs="&osm2pgsql_projection;">
     <StyleName>locks</StyleName>
     <Datasource>
      <Parameter name="table">
      (select way,waterway from &prefix;_point where waterway='lock_gate') as locks
      </Parameter>
      &datasource-settings;
    </Datasource>
</Layer>


