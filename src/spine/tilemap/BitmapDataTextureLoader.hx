package spine.tilemap;

import spine.support.graphics.TextureAtlas;
import openfl.display.BitmapData;
import openfl.Assets;
import spine.support.graphics.TextureLoader;
import openfl.display.Tileset;
import openfl.geom.Rectangle;
import zygame.utils.StringUtils;

class BitmapDataTextureLoader implements TextureLoader {

	private var _bitmapData:Map<String,BitmapData>;

	private var _tileset:Tileset;

	private var _ids:Map<AtlasRegion,Int>;

	public function new(bitmapDatas:Map<String,BitmapData>) {
		this._bitmapData = bitmapDatas;
	}

	public function loadPage (page:AtlasPage, path:String):Void {
		var bitmapData:BitmapData = this._bitmapData.get(StringUtils.getName(path));
		if (bitmapData == null)
			throw ("BitmapData not found with name: " + path);
		_tileset = new Tileset(bitmapData);
		_ids = new Map<AtlasRegion,Int>();
		page.rendererObject = this;
		page.width = bitmapData.width;
		page.height = bitmapData.height;
	}

	public function loadRegion (region:AtlasRegion):Void {
		var regionWidth:Int = region.rotate ? region.height : region.width;
		var regionHeight:Int = region.rotate ? region.width : region.height;
		var id:Int = _tileset.addRect(new Rectangle(region.x,region.y,regionWidth,regionHeight));
		_ids.set(region,id);
		if(!region.rotate)
		{
			region.width = region.packedWidth;
			region.height = region.packedHeight;
			// region.originalWidth = regionWidth;
			// region.originalHeight = regionHeight;
			// region.packedWidth = regionWidth;
			// region.packedHeight = regionHeight;
		}
		else
		{
			region.height = region.packedWidth;
			region.width = region.packedHeight;
			// region.originalHeight = regionWidth;
			// region.originalWidth = regionHeight;
			// region.packedHeight = regionWidth;
			// region.packedWidth = regionHeight;
		}
		// region.packedHeight = Std.int(regionHeight);
		// region.packedWidth = Std.int(regionWidth);
		// region.originalHeight = Std.int(regionHeight);
		// region.originalWidth = Std.int(regionWidth);
		// region.width = 200;
	}

	/**
	 * 获取渲染ID
	 * @param region 
	 * @return Int
	 */
	public function getID(region:AtlasRegion):Int
	{
		return _ids.get(region);
	}

	public function getTileset():Tileset
	{
		return _tileset;
	}

	public function unloadPage (page:AtlasPage):Void {
		_tileset.bitmapData.dispose();
	}
}