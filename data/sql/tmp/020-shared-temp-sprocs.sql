USE illustrated2
GO

if object_id('tempdb..##InsertName') IS NOT NULL
begin
    drop procedure ##InsertName
    if object_id('tempdb..##InsertName') is not null
        print '<<< failed dropping procedure ##InsertName >>>'
    else
        print '<<< dropped procedure ##InsertName >>>'
end
go

CREATE PROCEDURE ##InsertName (
	@Name VARCHAR(255),
	@Alphabetic VARCHAR(255),
	@Wikipedia VARCHAR(75) = NULL,
	@DataDate VARCHAR(50) = NULL,
	@DataType VARCHAR(50) = NULL,
	@NameType VARCHAR(20),
	@EntityTableId INT,
	@RelatedId INT,
	@NameTypeId INT,
	@NameSubtypeId INT,
	@SortOrder INT
) AS BEGIN
	-- Constants
	DECLARE @NameTypeFullId INT = 1001, @NameTypePartId INT = 1002
	DECLARE @NameSubtypeStandardId INT = 2001, @NameSubtypeFirstId INT = 2008, @NameSubtypeLastId INT = 2009, @NameSubtypeFormalId INT = 2002, @NameSubtypeOtherId INT = 2004, @NameSubtypeMiddleId INT = 2010
	DECLARE @NameSubtypeLookupId INT = 2019
	DECLARE @EntityTypeTechnologyId INT = 151027, @EntityCategoryTechnologyId INT = 151026, @DateAccuracyYearId INT = 100023
	DECLARE @DisplayOrderDefault INT = 9999, @DataMissing VARCHAR(20) = '????', @Technology VARCHAR(20) = 'Technology', @PrimaryIdEmpty INT = 19636

	-- Variables
	DECLARE @UniqueNameId INT, @NameId INT, @NameDataId INT, @FullName VARCHAR(255), @FullAlphabetic VARCHAR(255)

	IF @DataDate IS NULL OR @DataDate = '' SET @DataDate = @DataMissing
	IF @DataType IS NULL OR @DataType = '' SET @DataType = @Technology
	IF @DataType = 'null' SET @DataType = NULL
	IF @Wikipedia IS NULL OR @Wikipedia = '' SET @Wikipedia = @DataMissing

	SELECT @UniqueNameId = un.unique_name_id, @FullName = un.unique_name, @FullAlphabetic = un.alphabetic FROM unique_name un WHERE un.unique_name = @Name
	IF @UniqueNameId IS NULL BEGIN
		INSERT INTO unique_name (unique_name, alphabetic) VALUES (@Name, @Alphabetic)
		SELECT @UniqueNameId = un.unique_name_id, @FullName = un.unique_name, @FullAlphabetic = un.alphabetic FROM unique_name un WHERE un.unique_name = @Name
	END

	-- Ensure the name.name_id doesn't exist for this person/name (it shouldn't, but guard anyway)
	SELECT @NameId = name.name_id FROM name WHERE name.unique_name_id = @UniqueNameId AND name.entity_table_id = @EntityTableId AND name.related_id = @RelatedId
	IF @NameId IS NULL BEGIN
		INSERT INTO name (unique_name_id, entity_table_id, related_id, type_id, subtype_id, display_order) 
		VALUES (@UniqueNameId, @EntityTableId, @RelatedId, @NameTypeId, @NameSubtypeId, @SortOrder)
	END

	-- If this is the standard fullname, insert into name_data (and this single record per entity doesn't already exist)
	SELECT @NameDataId = nd.name_data_id FROM name_data nd WHERE nd.entity_table_id = @EntityTableId AND nd.related_id = @RelatedId
	IF @NameDataId IS NULL AND @NameTypeId = @NameTypeFullId AND @NameSubtypeId = @NameSubtypeStandardId BEGIN
		INSERT INTO name_data (entity_table_id, related_id, full_alphabetic, full_name, data1, data2, primary1_id, primary2_id, primary3_id, imdb, wiki, ibdb)
		VALUES (@EntityTableId, @RelatedId, @FullAlphabetic, @FullName, @DataDate, @DataType, @PrimaryIdEmpty, @PrimaryIdEmpty, @PrimaryIdEmpty, @DataMissing, @Wikipedia, @DataMissing)
	END

END
GO

if object_id('tempdb..##InsertUrl') IS NOT NULL
begin
    drop procedure ##InsertUrl
    if object_id('tempdb..##InsertUrl') is not null
        print '<<< failed dropping procedure ##InsertUrl >>>'
    else
        print '<<< dropped procedure ##InsertUrl >>>'
end
go

CREATE PROCEDURE ##InsertUrl (
	@Url VARCHAR(255),
	@EntityTableId INT,
	@RelatedId INT,
	@UrlTypeId INT,
	@CompanyId INT,
	@UrlName VARCHAR(255),
	@SortOrder INT
) AS BEGIN
	-- Variables
	DECLARE @UrlId INT

	IF @Url != '' BEGIN
		SELECT @UrlId = url.url_id FROM url WHERE url.entity_table_id = @EntityTableId AND url.related_id = @RelatedId AND url.url_type_id = @UrlTypeId AND url.url_name = @UrlName AND url.company_id = @CompanyId
		IF @UrlId IS NULL BEGIN
			INSERT INTO url (the_url, entity_table_id, related_id, url_type_id, company_id, url_name, sort_order, is_verified)
			VALUES (@Url, @EntityTableId, @RelatedId, @UrlTypeId, @CompanyId, @UrlName, @SortOrder, 1)
		END
	END
END
GO


if object_id('tempdb..##InsertBookNumber') IS NOT NULL
begin
    drop procedure ##InsertBookNumber
    if object_id('tempdb..##InsertBookNumber') is not null
        print '<<< failed dropping procedure ##InsertBookNumber >>>'
    else
        print '<<< dropped procedure ##InsertBookNumber >>>'
end
go

CREATE PROCEDURE ##InsertBookNumber (
	@Isbn VARCHAR(255),
	@Isbn10 VARCHAR(255),
	@BookId INT,
	@BookNumberTypeId INT,
	@BookNumberSubtypeId INT,
	@PublicationDate DATETIME = NULL,
	@DateAccuracyId INT = NULL
) AS BEGIN

	-- Constants
	DECLARE @DateAccuracyIdUnknown INT = 150494

	IF @DateAccuracyId IS NULL SET @DateAccuracyId = @DateAccuracyIdUnknown

	IF @Isbn IS NOT NULL AND @Isbn != 'NULL' BEGIN
		IF NOT EXISTS (SELECT * FROM book_number WHERE book_id = @BookId AND book_number_subtype_id = @BookNumberSubtypeId) BEGIN
			INSERT INTO book_number (book_id, book_number_type_id, isbn13, book_number, book_number_subtype_id, publication_date, date_accuracy_id)
			VALUES (@BookId, @BookNumberTypeId, @Isbn, @Isbn10, @BookNumberSubtypeId, @PublicationDate, @DateAccuracyIdUnknown)
		END
	END
END
GO

if object_id('tempdb..##InsertNote') IS NOT NULL
begin
    drop procedure ##InsertNote
    if object_id('tempdb..##InsertNote') is not null
        print '<<< failed dropping procedure ##InsertNote >>>'
    else
        print '<<< dropped procedure ##InsertNote >>>'
end
go

CREATE PROCEDURE ##InsertNote (
	@DailyDate VARCHAR(20),
	@EntityTableID INT,
	@RelatedId INT, 
	@NoteTypeId INT,
	@CompanyId INT = NULL,
	@Name VARCHAR(255) = NULL,
	@Note VARCHAR(4000) = NULL, 
	@SortOrder INT
) AS BEGIN

	-- Constants
	DECLARE @DateAccuracyIdUnknown INT = 150494
	DECLARE @NoteTypeIdDescription INT = 151035, @NoteTypeIdImage INT = 151031, @NoteTypeIdTwitterImageTags INT = 151038, @NoteTypeIdTwitter INT = 151037, @NoteTypeIdTweet INT = 151039, @NoteTypeIdBrief INT = 151036

	IF @Name IS NULL BEGIN
		SELECT @Name = CASE
			WHEN @NoteTypeId = @NoteTypeIdDescription THEN 'Publisher''s Description'
			WHEN @NoteTypeId = @NoteTypeIdImage THEN 'Book Image'
			WHEN @NoteTypeId = @NoteTypeIdTwitterImageTags THEN 'Twitter Image Tags'
			WHEN @NoteTypeId = @NoteTypeIdTwitter THEN 'Twitter ' + @DailyDate
			WHEN @NoteTypeId = @NoteTypeIdTweet THEN 'Tweet ' + @DailyDate
			WHEN @NoteTypeId = @NoteTypeIdBrief THEN 'Brief'
		END
	END

	IF NOT EXISTS (SELECT * FROM note WHERE note.entity_table_id = @EntityTableID AND note.related_id = @RelatedId AND note.type_id = @NoteTypeId) BEGIN
		INSERT INTO note (entity_table_id, related_id, type_id, company_id, note, sort_order, name)
		VALUES (@EntityTableID, @RelatedId, @NoteTypeId, @CompanyId, @Note, @SortOrder, @Name)
	END

END
GO
