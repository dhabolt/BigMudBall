USE illustrated2
/* CREATE TYPE Identifiers AS TABLE(Id INT NOT NULL PRIMARY KEY) */
GO

DECLARE @BookId INT = 0, 
		@DealDate VARCHAR(10) = null,
		@DailyDoseLink VARCHAR(200) = null,
		@IsPackt INT = 0, 
		@IsManning INT = 0, 
		@IsApress INT = 0, 
		@IsPluralsightFree INT = 0,
		@IsInformIT INT = 0,
		@IsSpringerDaily INT = 0,
		@IsNewBook INT = 0, 
		@IsNewApress INT = 0,
		@IsNewOReilly INT = 0,
		@IsNewVideo INT = 0,
		@NewIncremental VARCHAR(2) = '1',
		@ThingIds AS Identifiers,
		@InformItDeal VARCHAR(20) = '50% off'
INSERT @ThingIds(Id) VALUES (50471),(50472),(50447),(50452),(50436),(-5),(-6),(-7),(-8),(-9),(-10)

SELECT @BookId = 50436, @IsManning = 1, @NewIncremental = '3', @InformItDeal = '', @DealDate = '10/04', @DailyDoseLink = '/daily/2017/10/04/'

-- ENTITY CONSTANTS
DECLARE @BookEntityId INT = 8, @PersonEntityId INT = 1, @ThingEntityId INT = 50001

-- CONSTANTS
DECLARE @DescriptionTypeId INT = 151035, @ImageTypeId INT = 151031, @AuthorTypeId INT = 100320, @BiblioTypeIdThing INT = 151030, @BiblioTypeIdBookAbout INT = 100584, @PublisherTypeId INT = 150622, @ForwardTypeId INT = 100600
DECLARE @UrlTypeHomeId INT = 28004
DECLARE @PublishersDescription VARCHAR(30) = '#### Publisher''s Description' + CHAR(13) + CHAR(10)
DECLARE @PacktDealUrl VARCHAR(255) = 'https://www.packtpub.com/packt/offers/free-learning', @ManningDealUrl VARCHAR(255) = 'https://www.manning.com/dotd'
DECLARE @PluralsightFreeUrl VARCHAR(255) = 'https://learn.pluralsight.com/resource/free-course/free-weekly-course', @InformItDealsUrl VARCHAR(255) = 'http://www.informit.com/deals/'
DECLARE @ApressAffiliatePrepend VARCHAR(255) = 'http://www.anrdoezrs.net/links/8423497/type/dlg/'
DECLARE @InformItAffiliatePrepend VARCHAR(255) = 'https://click.linksynergy.com/deeplink?id=O7eD6EjdUAQ&mid=24808&murl='

-- VARIABLES
DECLARE @Authors VARCHAR(8000), @Things VARCHAR(8000), @AllThings VARCHAR(8000), @Title VARCHAR(255), @TitleUrl VARCHAR(255), @TitleImage VARCHAR(255), @TitleDescription VARCHAR(max)
DECLARE @Subtitle VARCHAR(255), @Forwards VARCHAR(8000), @FowardsCopy VARCHAR(8000), @JumpName VARCHAR(50)


-- ##############################
-- SELECT Reusable Variables
-- ##############################
SELECT @Title = book.name, @Subtitle = ISNULL(book.subtitle,'') FROM book WHERE book_id = @BookId
SELECT @TitleUrl = url.the_url FROM url WHERE url_type_id = @UrlTypeHomeId AND related_id = @BookId AND url.entity_table_id = @BookEntityId
SELECT @TitleImage = note.note FROM note WHERE type_id = @ImageTypeId AND entity_table_id = @BookEntityId AND related_id = @BookId

-- Handle Affiliate Links
if @IsNewApress = 1 OR @IsApress = 1 OR @IsNewOReilly = 1 BEGIN
	SELECT @TitleUrl = @ApressAffiliatePrepend + @TitleUrl
	if @IsNewApress = 1 SELECT @IsNewBook = 1
	if @IsNewOReilly = 1 SELECT @IsNewBook = 1
END

IF @IsInformIT = 1 BEGIN
	SELECT @TitleUrl = @InformItAffiliatePrepend + @TitleUrl
	SELECT @InformItDealsUrl = @InformItAffiliatePrepend + @InformItDealsUrl
END

-- TODO: Add Editor and Technical Editor as postpends to Author (similar to Forwards below)
SELECT @Forwards = COALESCE(@Forwards + ', ', '') + un.unique_name 
FROM bibliography biblio
INNER JOIN name on biblio.name_id = name.name_id
INNER JOIN unique_name un ON name.unique_name_id = un.unique_name_id
INNER JOIN name_data nd ON name.entity_table_id = nd.entity_table_id AND name.related_id = nd.related_id
INNER JOIN person on name.related_id = person.person_id AND name.entity_table_id = @PersonEntityId
WHERE biblio.biblio_type_id = @ForwardTypeId AND biblio.entity_table_id = @BookEntityId AND biblio.related_id = @BookId

SELECT @FowardsCopy =
CASE 
	WHEN @Forwards IS NULL THEN ''
	ELSE ' with foreword by ' + @Forwards
END

SELECT @Authors = COALESCE(@Authors + ', ', '') + un.unique_name 
FROM bibliography biblio
INNER JOIN name on biblio.name_id = name.name_id
INNER JOIN unique_name un ON name.unique_name_id = un.unique_name_id
INNER JOIN name_data nd ON name.entity_table_id = nd.entity_table_id AND name.related_id = nd.related_id
INNER JOIN person on name.related_id = person.person_id AND name.entity_table_id = @PersonEntityId
WHERE biblio.biblio_type_id = @AuthorTypeId AND biblio.entity_table_id = @BookEntityId AND biblio.related_id = @BookId

SELECT @Authors = @Authors + @FowardsCopy

SELECT @Things = COALESCE(@Things + ', ', '') + un.unique_name 
FROM bibliography biblio
INNER JOIN name ON biblio.name_id = name.name_id
INNER JOIN unique_name un ON name.unique_name_id = un.unique_name_id
INNER JOIN name_data nd ON name.entity_table_id = nd.entity_table_id AND name.related_id = nd.related_id
INNER JOIN thing ON name.related_id = thing.thing_id AND name.entity_table_id = @ThingEntityId
WHERE (biblio.biblio_type_id = @BiblioTypeIdThing OR biblio.biblio_type_id = @BiblioTypeIdBookAbout) AND biblio.entity_table_id = @BookEntityId AND biblio.related_id = @BookId

if @Things IS NULL SELECT @Things = ''

SELECT @AllThings = COALESCE(@AllThings + ', ', '') + un.unique_name 
FROM bibliography biblio
INNER JOIN name ON biblio.name_id = name.name_id
INNER JOIN unique_name un ON name.unique_name_id = un.unique_name_id
INNER JOIN name_data nd ON name.entity_table_id = nd.entity_table_id AND name.related_id = nd.related_id
INNER JOIN thing ON name.related_id = thing.thing_id AND name.entity_table_id = @ThingEntityId
WHERE (biblio.biblio_type_id = @BiblioTypeIdThing OR biblio.biblio_type_id = @BiblioTypeIdBookAbout) AND biblio.entity_table_id = @BookEntityId AND biblio.related_id IN (SELECT Id FROM @ThingIds)
ORDER BY un.alphabetic

-- Reduce Header Level by 1
SELECT @TitleDescription = REPLACE(CAST(note.note AS NVARCHAR(max)), '## ', '#### ')
FROM note 
WHERE note.type_id = @DescriptionTypeId AND note.entity_table_id = @BookEntityId AND note.related_id = @BookId
--SELECT @TitleDescription = REPLACE(CAST(@TitleDescription AS NVARCHAR(max)), '#### ', '###### ')
--SELECT @TitleDescription = REPLACE(CAST(@TitleDescription AS NVARCHAR(max)), '### ', '##### ')
--SELECT @TitleDescription = REPLACE(CAST(@TitleDescription AS NVARCHAR(max)), '## ', '#### ')

-- Prepend constant Publisher's Description if we don't start with a header
SELECT @TitleDescription =
CASE 
	WHEN @TitleDescription LIKE '##%' THEN @TitleDescription
	ELSE @PublishersDescription + @TitleDescription
END

-- ##############################
-- Output the Results
-- ##############################

IF @IsPackt = 1 BEGIN
	SELECT @JumpName = 'packt-daily'

	SELECT '* [' + @Title + '](#' + @JumpName + ')' AS JumpLink

	SELECT '### <a name="' + @JumpName + '"></a><small>Free</small> [' + @Title + '](' + @PacktDealUrl + ') ' + @Subtitle AS TitleUrl

	SELECT '[![' + @Title + '](' + @TitleImage + ')](' + @PacktDealUrl + ')' AS TitleUrl

	SELECT '[Free Packt eBook](' + @PacktDealUrl + ') by ' + @Authors +' (valid through ' + @DealDate + ' at 19:00 EST). This book covers ' + @Things + '.' 

	SELECT @TitleDescription AS TitleDescription
END

IF @IsManning = 1 BEGIN
	SELECT @JumpName = 'manning-daily-' + @NewIncremental

	SELECT '* [' + @Title + '](#' + @JumpName + ')' AS JumpLink

	SELECT '### <a name="' + @JumpName + '"></a><small>50% off</small> [' + @Title + '](' + @ManningDealUrl + ') ' + @Subtitle AS TitleUrl

	SELECT '[![' + @Title + '](' + @TitleImage + ')](' + @ManningDealUrl + ')' AS TitleUrl

	SELECT '[50% off Manning''s eBook](' + @ManningDealUrl + ') by ' + @Authors +'. This book covers ' + @Things + '.' 

	SELECT @TitleDescription AS TitleDescription
END

IF @IsApress = 1 BEGIN
	SELECT @JumpName = 'apress-daily'

	SELECT '* [' + @Title + '](#' + @JumpName + ') ' + @Subtitle AS JumpLink

	SELECT '### <a name="' + @JumpName + '"></a><small>$9.99</small> [' + @Title + '](' + @TitleUrl + ')' AS TitleUrl

	SELECT '[![' + @Title + '](' + @TitleImage + ')](' + @TitleUrl + ')' AS TitleUrl

	SELECT '[$9.99 Apress eBook](' + @TitleUrl + ') by ' + @Authors +'. This book covers ' + @Things + '.' 

	SELECT @TitleDescription AS TitleDescription
END

IF @IsPluralsightFree = 1 BEGIN
	SELECT @JumpName = 'pluralfree'

	SELECT '* [' + @Title + '](#' + @JumpName + ') ' + @Subtitle AS JumpLink

	SELECT '### <a name="' + @JumpName + '"></a><small>Free</small> [' + @Title + '](' + @PluralsightFreeUrl + ')' AS TitleUrl

	SELECT '[![' + @Title + '](' + @TitleImage + ')](' + @PluralsightFreeUrl + ')' AS TitleUrl

	SELECT '[Free Pluralsight course (one week)](' + @PluralsightFreeUrl + ') by ' + @Authors +'. This course covers ' + @Things + '.' 

	SELECT @TitleDescription AS TitleDescription
END

IF @IsInformIT = 1 BEGIN
	SELECT @JumpName = 'informit-daily'

	SELECT '* [' + @Title + '](#' + @JumpName + ') ' + @Subtitle AS JumpLink

	SELECT '### <a name="' + @JumpName + '"></a><small>' + @InformItDeal + '</small> [' + @Title + '](' + @InformItDealsUrl + ')' AS TitleUrl

	SELECT '[![' + @Title + '](' + @TitleImage + ')](' + @InformItDealsUrl + ')' AS TitleUrl

	SELECT '[' + @InformItDeal + ' InformIT eBook](' + @InformItDealsUrl + ') by ' + @Authors +'. This book covers ' + @Things + '.' 

	SELECT @TitleDescription AS TitleDescription
END

IF @IsSpringerDaily = 1 BEGIN
	SELECT @JumpName = 'springer-daily'

	SELECT '* [' + @Title + '](#' + @JumpName + ') ' + @Subtitle AS JumpLink

	SELECT '### <a name="' + @JumpName + '"></a><small>$19.99</small> [' + @Title + '](' + @TitleUrl + ')' AS TitleUrl

	SELECT '[![' + @Title + '](' + @TitleImage + ')](' + @TitleUrl + ')' AS TitleUrl

	SELECT '[$19.99 Springer eBook](' + @TitleUrl + ') by ' + @Authors +'. This book covers ' + @Things + '.' 

	SELECT @TitleDescription AS TitleDescription
END

IF @IsNewBook = 1 BEGIN
	SELECT @JumpName = 'new' + @NewIncremental

	SELECT '* [' + @Title + '](#' + @JumpName + ')' AS JumpLink

	SELECT '### <a name="' + @JumpName + '"></a>[' + @Title + '](' + @TitleUrl + ')' AS TitleUrl

	SELECT '[![' + @Title + '](' + @TitleImage + ')](' + @TitleUrl + ')' AS TitleUrl

	SELECT '[' + @Title + '](' + @TitleUrl + ') ' +  + @Subtitle + ' by ' + @Authors +'. This book covers ' + @Things + '.' 

	SELECT @TitleDescription AS TitleDescription
END

IF @IsNewVideo = 1 BEGIN
	SELECT @JumpName = 'new' + @NewIncremental

	SELECT '* [' + @Title + '](#' + @JumpName + ')' AS JumpLink

	SELECT '### <a name="' + @JumpName + '"></a>[' + @Title + '](' + @TitleUrl + ')' AS TitleUrl

	SELECT '[![' + @Title + '](' + @TitleImage + ')](' + @TitleUrl + ')' AS TitleUrl

	SELECT '[' + @Title + '](' + @TitleUrl + ') ' +  + @Subtitle + ' by ' + @Authors +'. This video covers ' + @Things + '.' 

	SELECT @TitleDescription AS TitleDescription
END

SELECT '<div class="image-box"><a href="{{site.url}}' + @DailyDoseLink + '#' + @JumpName + '"><img class="resize" alt="' + @Title + '" src="' + @TitleImage + '"/></a></div>' AS BlogImageJumpLink

SELECT @AllThings AS AllThingsForToday

