#pragma once
#include "Generated/Scripts.hpp"
#include "FastVector.hpp"
#include "Render/Mesh.hpp"

#define PREVIEW_ZNEAR 1.0
#define PREVIEW_ZFAR 10000.0
#define PREVIEW_ZOOM_MIN 1.0
#define PREVIEW_ZOOM_MAX 2000.0
#define PREVIEW_TEXTURE_SIZE 64
#define PREVIEW_UNLOAD_DISTANCE 1500

#define REGION_CHUNKS 1024
#define REGION_SECTIONS_X 32
#define REGION_SECTIONS_XZ 1024
#define REGION_SECTIONS_SIZE 25600
#define REGION_SIZE 512
#define REGION_SIZE_CHUNKS 32
#define REGION_BOUNDARY_LOAD_SIZE 100

#define CHUNK_SECTIONS 25
#define CHUNK_SECTION_MIN -4
#define CHUNK_HEIGHT_MAX 320
#define CHUNK_HEIGHT_MIN -64
#define CHUNK_HEIGHT_SIZE 384

#define SECTION_SIZE 16
#define SECTION_SIZEM1 15
#define SECTION_SIZE2 256
#define SECTION_SIZE3 4096

#undef TRANSPARENT

namespace CppProject
{
	struct BuilderSection;
	struct Chunk;
	struct Map;
	struct NbtCompound;
	struct Preview;
	struct Region;
	struct RegionLoader;
	struct Script;
	struct Section;
	struct Shader;
	struct Sprite;
	struct Surface;
	struct Texture;
	struct VertexBuffer;

	// World vector with integer x/y/z components.
	struct WorldVec
	{
		WorldVec() {}
		WorldVec(const VecType& vec) : x(vec.x), y(vec.y), z(vec.z) {}
		WorldVec(IntType x, IntType y, IntType z) : x(x), y(y), z(z) {}

		WorldVec operator+(const WorldVec& vec) const;
		WorldVec operator-(const WorldVec& vec) const;
		WorldVec operator*(const WorldVec& vec) const;
		WorldVec operator+(IntType in) const;
		WorldVec operator-(IntType in) const;
		WorldVec operator*(IntType in) const;
		operator VecType() const;

		IntType x, y, z;
	};

	// World box with a start (inclusive) and end position (exclusive)
	struct WorldBox
	{
		WorldBox() {};
		WorldBox(const WorldVec& start, const WorldVec& end) :
			active(true), start(start), end(end) {}

		void Adjust();
		WorldVec GetStart() const;
		WorldVec GetEnd() const;
		VecType GetSize() const { return GetEnd() - GetStart(); };
		BoolType Contains(const WorldVec& pos) const;
		BoolType Intersects(const WorldBox& other) const;

		BoolType active = false;
		WorldVec start, end;
	};

	// Compressed block vertex
	struct WorldVertex
	{
		WorldVertex(const WorldVec& regionPos, uint16_t blockData);

		// Setup shader attributes
		static void SetAttributes();

		uint32_t pos; // XYZ block position in the region (10 bits each)
		uint32_t data; // 10 bits UV + 6 bits light 
	};

	// Stores color tint of a biome.
	struct BiomeTint
	{
		IntType grass, foliage; //, water; //fix water tint
	};

	// Determines how a block will be rendered in the preview, compressed into a 8 bit value.
	struct PreviewState
	{
		PreviewState() {}
		PreviewState(BoolType isBlock, BoolType solid, BoolType waterlogged, uint8_t light) :
			value((waterlogged << 6) | (solid << 5) | (isBlock << 4) | (std::min((int)light, 15))) {}

		inline BoolType IsBlock() const { return (value >> 4) & 1; }
		inline BoolType IsSolid() const { return (value >> 5) & 1; }
		inline BoolType IsWaterlogged() const { return (value >> 6) & 1; }
		inline uint8_t GetLight() const { return value & 15; }

		uint8_t value;
	};

	// Style of a block defined by a 16 bit top and side pixel index on the texture and optional tint.
	struct BlockStyle
	{
		enum TintType : int;
		BlockStyle() {};
		BlockStyle(uint16_t topPos, uint16_t sidePos, BoolType isTransparent, TintType tint, uint8_t light);

		// Create a new BlockStyle or re-use an existing one.
		static int16_t Create(IntType colorTop, RealType alphaTop = 1.0, IntType colorSide = -1, RealType alphaSide = 1.0, TintType tint = NONE, uint8_t light = 0);

		enum TintType : int
		{
			NONE,
			GRASS,
			FOLIAGE
			//WATER //fix water tint
		};

		uint16_t topPos, sidePos;
		TintType tint = NONE;
		uint16_t index = 0;

		static FastVector<BlockStyle*> blockStyles;
		static FastVector<PreviewState> blockPreviewStates;
		static QVector<QColor> previewColors;
		static QImage previewImage;
		static Texture* previewTexture;
		static BlockStyle* airStyle;
		static BlockStyle* bedrockStyle;
	};

	// Block entity found in a chunk at a position relative to the selection box.
	struct BlockEntity
	{
		WorldVec pos;
		Script* script = nullptr;
		NbtCompound* nbt = nullptr;
		Map* map = nullptr;
	};

	// Determines how a block will be generated by the scenery builder.
	struct BuilderState
	{
		uint16_t blockId = 0, stateId = 0;
		BoolType waterlogged = false;
	};

	// Stores info about a saved world.
	struct SaveInfo
	{
		QString name;
		BoolType hasPlayer;
		VecType spawnPos, playerPos, playerRot;
		QString playerDim;
		QHash<QString, QDir> dimDir;
	};

	// Handles regions in an opened world
	struct World
	{
		// Initialize lookup tables and generate preview texture.
		static void Init();

		// Opens the world at the given regions directory, returns whether successful.
		static void Open(QDir regionsDir);

		// Closes the currently opened world.
		static void Close();

		// Generates a collection of builder sections from a box in the opened world,.
		static void GenerateBuilderSections(const WorldBox& box);

		// Adds a save from the given root directory, returns whether successful.
		static BoolType AddSave(QString dir);

		// Apply the selected block filter settings, returns whether the world needs reloading.
		static BoolType ApplyFilter();

		// Block filter mode
		enum FilterMode
		{
			REMOVE = 0,
			KEEP = 1
		};

		static QDir currentRegionsDir;
		static Preview* preview;
		static QVector<Region*> regions;
		static QHash<QString, SaveInfo> saves;
		static QHash<StringType, BoolType> mcBlockIdWaterloggedMap, filteredMcBlockIdWaterloggedMap;
		static BoolType waterRemoved;
	};

	// 3D preview viewport
	struct Preview : public QObject
	{
		Q_OBJECT
	public slots:
		// Resets the preview and opens the selected world/dimension in the dropdown list.
		void Reset();

		// Confirm the selection.
		void Confirm();

		// Cancel the world import.
		void Cancel();

	public:
		Preview();

		// Update the 3D viewport by rendering to the given surface.
		void Update(Surface* surface, QRect rect, QRect confirmRect);

		// Set the camera position when orbiting around the target.
		void UpdateCameraPosition();

		// Set the camera target when the position/look direction changes.
		void UpdateCameraTarget();

		// Update the surface caches when the camera changes.
		void UpdateSurfaces();

		// Update the surface of box resizing.
		void UpdateBoxResizeSurface();

		// Returns the world position of the given point on a rendered surface.
		VecType GetWorldPosition(Surface* surface, QPoint point, float& outDepth);

		// Go to the player or start position.
		void GoToPlayer();

		// Set selection size.
		void SetSelectionSize(VecType size);

		// Loads all regions near the given X/Z position.
		void LoadRegions(IntType x, IntType z);

		// Input mode
		enum Mode
		{
			OPENWORLD,
			DEFAULT,
			CLICK,
			SELECT,
			RESIZE,
			ROTATE,
			PAN,
			FLY_BEGIN,
			FLY
		};

		Mode mode = DEFAULT;
		BoolType hasPlayer = false, resetUpdate = false;
		QString dimension = "";
		Matrix matrixV, matrixP, playerM, selectionM;
		RealType camAngleXY, camAngleZ, camTargetDis;
		VecType camPos, camTarget, spawnPos, playerPos, playerRot;
		struct
		{
			IntType startTime, length = 0;
			VecType posStart, posEnd;
			RealType targetDisStart, targetDisEnd;
			RealType angleXYStart, angleXYEnd;
			RealType angleZStart, angleZEnd;
			BoolType animateCamPos = false;
		} camAnim;
		QVector<Region*> openLoadRegions;
		WorldVec worldOriginPos;

		WorldBox selection, resizeStartSelection;
		float mouseDepth = 1.0;
		WorldVec mouseBlock;
		IntType mouseButton, mouseClickX, mouseClickY, mouseLastX, mouseLastY;
		BoolType mouseLocked = false, resizeDirValid = false;
		VecType mouseWorldPos, resizeDir, resizeStartPos;

		VertexBuffer* cube = nullptr;
		VertexBuffer* cubeInv = nullptr;
		VertexBuffer* plane = nullptr;
		VertexBuffer* playerHead = nullptr;
		Sprite* playerHeadTex = nullptr;

		Shader* shaderChecker = nullptr;
		Shader* shaderPreview = nullptr;
		Shader* shaderBox = nullptr;
		Shader* shaderBoxResize = nullptr;
		Shader* shaderPlayer = nullptr;
		Surface* resizeSurface = nullptr;

		RealType flyMoveSpeed, flyLookSensitivity, flyFastMod, flySlowMod;

		static QVector<BiomeTint> biomeTints;
		static QHash<StringType, uint16_t> mcBlockIdStyleIndexMap, filteredMcBlockIdStyleIndexMap;
		static QHash<StringType, uint16_t> mcBiomeIdIndexMap;
		static uint16_t filteredMcLegacyBlockIdStyleIndex[256][16];
	};

	// A collection of up to 32x32 chunks.
	struct Region
	{
		Region(QString filename);
		~Region();

		// Load the region chunks on a separate thread.
		void Load(const WorldBox& box = WorldBox());

		// Returns the current loading progress as a value between 0-1.
		RealType GetLoadProgress();

		// Unload the region data and meshes.
		void Unload();

		// Generate triangles when first loaded or new adjacent regions are loaded.
		enum GenerateMode : int;
		void GeneratePreview(GenerateMode mode = FIRST);

		// Update the region mesh from the chunk triangles.
		void UpdateMesh();

		// Update the region vertex and index buffers.
		void UpdateBuffers();

		// Adds a fully loaded adjacent region.
		enum Direction : int;
		void AddAdjacent(Direction direction, Region* region);

		// Returns the render state of a block at a position within the region.
		PreviewState GetPreviewState(const WorldVec& pos, GenerateMode mode);

		// Returns a region at a position, or nullptr if unavailable.
		enum LoadStatus : int;
		static Region* Find(IntType x, IntType z, LoadStatus loadStatus);

		// Load status
		enum LoadStatus : int
		{
			UNLOADED,
			LOADING,
			LOAD_ERROR,
			LOADED
		};

		// Mesh status
		enum MeshStatus : int
		{
			NOMESH,
			UPDATE_MESH,
			UPDATE_BUFFERS,
			READY
		};

		// Chunk status
		enum ChunkStatus : int
		{
			CHUNK_EMPTY = 0,
			CHUNK_LOADED = 1,
			CHUNK_MESH_READY = 2,
			CHUNK_MESH_COPIED = 3
		};

		// Adjacent direction
		enum Direction : int
		{
			RIGHT,
			LEFT,
			FRONT,
			BACK,
			DirectionAmount
		};

		// Generation mode
		enum GenerateMode : int
		{
			FIRST,
			RIGHT_EDGE, // X+
			LEFT_EDGE, // X-
			FRONT_EDGE, // Z+
			BACK_EDGE, // Z-
			LEFT_BACK_CORNER, // 0,0
			RIGHT_BACK_CORNER, // 1,0
			RIGHT_FRONT_CORNER, // 1,1
			LEFT_FRONT_CORNER, // 0,1
			GenerateModeAmount
		};

		// Meshes
		enum MeshType : int
		{
			DEFAULT,
			TRANSPARENT,
			MeshTypeAmount
		};

		QString name, filename, dimName;
		BoolType anvilFormat = true, legacy = false, unload = false, updateBuffers = false;
		IntType x, z;
		WorldVec pos;
		Chunk* chunks[REGION_CHUNKS];
		ChunkStatus chunkStatus[REGION_CHUNKS];
		IntType numChunks = 0;
		Section* loadedSections[REGION_SECTIONS_SIZE];
		LoadStatus loadStatus = UNLOADED;
		MeshStatus meshStatus = NOMESH;
		Region* adjacent[DirectionAmount];
		BoolType generated[GenerateModeAmount];
		IntType generatedAmount = 0;
		RealType loadProgress = 0.0, loadProgressTarget = 0.0;
		IntType numTimelines = 0;

		// Per layer mesh data
		struct MeshData
		{
			IntType numVertices = 0, numIndices = 0;
			BoolType changed = false, loaded = false;
			Mesh<WorldVertex> mesh;
		};
		MeshData meshData[MeshTypeAmount];

		static RegionLoader* loader;
	};

	// Load regions on a separate thread
	struct RegionLoader : public QObject
	{
		Q_OBJECT
	public:
		RegionLoader();

	signals:
		void UpdateDone();

	public slots:
		void UpdateLoadRegions();

	public:
		BoolType active = true;
	};

	// A collection of sections
	struct Chunk
	{
		Chunk(Region* region, QByteArray& data, const WorldBox& box);
		~Chunk();

		// Generate triangles to add to the region mesh.
		void GeneratePreview(Region::GenerateMode mode = Region::FIRST);

		// Generate the triangles to render a face in a direction.
		enum FaceDirection : int;
		struct Mesh;
		struct FaceData;
		void GenerateFaceTriangles(Mesh& mesh, FaceDirection dir, Heap<FaceData>& faceData, uint16_t x, uint16_t y, uint16_t z, const WorldVec& startPos, const WorldVec& endPos);

		// Free unused preview data.
		void FreePreviewData();

		// Block format
		enum Format : int
		{
			PRE_JAVA_1_2, // Pre-Anvil, 128 height limit
			JAVA_1_2, // Anvil format, sections with byte arrays
			JAVA_1_13 = 1451, // The flattening, palettes in sections
			JAVA_1_16 = 2529, // Long array index bits snapped to 64
			JAVA_1_18 = 2838 // Lowercase keys in sections
		};

		// Face direction
		enum FaceDirection : int
		{
			RIGHT,
			LEFT,
			TOP,
			BOTTOM,
			FRONT,
			BACK,
			FaceDirectionAmount
		};

		// Stores the faces added to a block in the section.
		struct FaceData
		{
			uint16_t blockData[FaceDirectionAmount];
		};

		// Stores the vertices in a chunk.
		struct VertexData
		{
			uint16_t blockData;
			uint32_t index;
		};

		IntType x, z, regionIndex = 0;
		WorldVec regionPos;
		Region* region = nullptr;
		Format format;
		Section* sections[CHUNK_SECTIONS];
		Heap<uint16_t> legacyBiomes;
		BoolType leftEdge, rightEdge, backEdge, frontEdge;
		BoolType error = false;
		QVector<BlockEntity> blockEntities;
		IntType numTimelines = 0;

		struct Mesh
		{
			Heap<FaceData> faceData[CHUNK_SECTIONS];
			Heap<VertexData> vertexData[CHUNK_SECTIONS];
			FastVector<WorldVertex> vertices;
			FastVector<uint32_t> indices;
			IntType vertexOffset, indexOffset; // Offset in region mesh
		} meshes[Region::MeshTypeAmount];

		IntType faceDataSizeX, faceDataSizeXZ, faceDataSizeTotal;
		IntType vertexDataSizeX, vertexDataSizeXZ, vertexDataSizeTotal;
	};

	// A section with up to 16x16x16 blocks for storing 3D preview or scenery builder data.
	struct Section
	{
		Section(const WorldVec& pos, const WorldVec& size) { InitBuilderData(pos, size); }
		Section(Chunk* chunk, IntType y, const WorldBox& box);
		~Section();

		// Load the section blocks and biomes from the given NBT structure, returning whether successful.
		BoolType Load(NbtCompound* nbt, Chunk::Format format);

		// Parse block palette for the preview.
		void ParseBlockPalettePreview(NbtCompound* nbt, StringType paletteName, StringType dataName, Chunk::Format format);

		// Parse biome palette for the preview.
		void ParseBiomePalettePreview(NbtCompound* nbt, Chunk::Format format);

		// Parse a long array of block/biome palette indices.
		void ParsePaletteIndices(const Heap<int64_t>& dataArray, Heap<uint16_t>& paletteIndices, IntType paletteSize, Chunk::Format format, IntType minBits = 1);

		// Generate the faces of a solid/transparent block in the section.
		void GenerateFaces(Region::GenerateMode mode, const WorldVec& startPos, const WorldVec& endPos);

		// Returns the preview state of a block in the section or region.
		PreviewState GetPreviewState(const WorldVec& pos, Region::GenerateMode mode);

		// Allocate the data needed for the scenery builder.
		void InitBuilderData(const WorldVec& pos, const WorldVec& size);

		// Parse block palette for the builder.
		void ParseBlockPaletteBuilder(NbtCompound* nbt, StringType paletteName, StringType dataName, Chunk::Format format);

		// Adds a new builder state to the palette and returns its new index or returns an existing one with matching values.
		IntType AddBuilderState(const BuilderState& state);

		// Returns the block offset in the section from the given builder coordinates.
		IntType GetBlockOffset(const WorldVec& pos);

		// Returns the palette entry at a position in the section from the given builder coordinates.
		BuilderState& GetBuilderState(const WorldVec& pos);

		// Returns the render model id at a position in the section from the given builder coordinates.
		int16_t& GetRenderModel(const WorldVec& pos);

		IntType chunkIndex = 0;
		Chunk* chunk = nullptr;
		Region* region = nullptr;

		// The type of data stored in the section
		enum DataType
		{
			NONE,
			PREVIEW,
			BUILDER,
		} dataType = NONE;

		// Preview data
		struct PreviewData
		{
			WorldVec regionPos;
			BoolType hasBlocks = false, hasTransparent = false, hasLight = false, hideBedrock = false;
			Heap<uint16_t> blockStyleIndices;
			BlockStyle* singleBlockStyle = nullptr;
			Heap<PreviewState> states;
			PreviewState singleState;
			Heap<uint16_t> biomeIndices;
			uint8_t singleBiomeIndex = 0;
		} preview;

		// Builder data
		struct BuilderData
		{
			WorldVec pos, size;
			IntType sizeXY, sizeTotal;
			FastVector<BuilderState> palette;
			Heap<uint16_t> paletteIndices;
			Heap<int16_t> renderModelIds;
			FastVector<ArrType> renderModelMultipartIds;
		} builder;

	private:
		WorldVec blockStart = { 0, 0, 0 }, blockEnd;
		static uint8_t blockFaceBaseLight[Chunk::FaceDirectionAmount];
	};

	// Handles scenery generation from an imported .schematic or world box.
	struct Builder
	{
		// Returns a builder section from the given builder coordinates.
		static Section* GetSection(const WorldVec& pos);

		static Heap<Section*> sections;
		static WorldVec size, offset, sectionsDim;
		static IntType sectionsXY;
		static QHash<StringType, obj_block*> mcBlockIdObjMap, filteredMcBlockIdObjMap;
		static QHash<StringType, ArrType> mcBlockIdStateVarsMap;
		static obj_block* filteredMcLegacyBlockIdObj[256][16];
		static Heap<obj_block*> blocks;
		static Heap<obj_block_render_model*> renderModels;
	};
}
