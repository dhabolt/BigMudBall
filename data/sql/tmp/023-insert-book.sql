USE illustrated2
GO

DECLARE @StandardName VARCHAR(255) = 'TITLE', @StandardAlphabetic VARCHAR(255) = 'TITLE',
		@DailyDate VARCHAR(20) = '2017.10.07',
		@EntityType VARCHAR(10) = 'Book',
		@IsbnPaperback VARCHAR(30) = 'NULL', @IsbnPaperback10 VARCHAR(30) = 'NULL',
		@IsbnDigital VARCHAR(30) = 'NULL', @IsbnDigital10 VARCHAR(30) = 'NULL',
		@HomeUrl VARCHAR(255) = '', @AmazonUrl VARCHAR(255) = '',
		@NumberPages INT = 0,
		@DatePublished DATETIME = '',
		@DataDate VARCHAR(50) = '', @DataType VARCHAR(50) = '',
		@Subtitle VARCHAR(255) = '',
		@Wikipedia VARCHAR(75) = '',
		@OtherName1 VARCHAR(255) = '', @OtherAlphabetic1 VARCHAR(255) = '',
		@OtherName2 VARCHAR(255) = '', @OtherAlphabetic2 VARCHAR(255) = '',
		@OtherName3 VARCHAR(255) = '', @OtherAlphabetic3 VARCHAR(255) = ''


-- Constants
DECLARE @EntityTableIdBook INT = 8
DECLARE @NameTypeIdFull INT = 1001, @NameTypeIdPart INT = 1002
DECLARE @NameSubtypeIdStandard INT = 2001, @NameSubtypeIdOther INT = 2004
DECLARE @NameSubtypeIdLookup INT = 2019
DECLARE @EntityTypeIdBook INT = 151033, @EntityTypeIdVideo INT = 151032, @EntityCategoryIdTechnology INT = 151026
DECLARE @DateAccuracyIdYear INT = 100023, @DateAccuracyIdDay INT = 100027, @DateAccuracyIdUnknown INT = 150494
DECLARE @DisplayOrderDefault INT = 9999, @DataMissing VARCHAR(20) = '????', @Technology VARCHAR(20) = 'Technology', @PrimaryIdEmpty INT = 19636
DECLARE @UrlTypeIdHome INT = 28004, @UrlTypeIdSocial INT = 150715, @UrlTypeIdOther INT = 28005, @UrlTypeIdBlog INT = 28010
DECLARE @BookTypeIdTechnology INT = 151028, @BookSubtypeIdUncategorized INT = 150646, @BookNumberSubtypeIdDigital INT = 151029
DECLARE @BookNumberTypeIdIsbn INT = 37001, @BookNumberSubtypeIdPaperback INT = 150680
DECLARE @CompanyIdAmazon INT = 50990
DECLARE @NoteTypeIdDescription INT = 151035, @NoteTypeIdImage INT = 151031, @NoteTypeIdTwitterImageTags INT = 151038, @NoteTypeIdTwitter INT = 151037, @NoteTypeIdTweet INT = 151039, @NoteTypeIdBrief INT = 151036

-- Variables
DECLARE @UniqueNameId INT, @NameId INT, @BookId INT, @FullName VARCHAR(255), @FullAlphabetic VARCHAR(255), @EntityTypeId INT

SET NOCOUNT ON

SET @EntityTypeId = @EntityTypeIdBook
IF @EntityType = 'Video' SET @EntityTypeId = @EntityTypeIdVideo
IF @Subtitle = '' SET @Subtitle = NULL

BEGIN TRANSACTION

BEGIN TRY
	SELECT @BookId = book_id FROM book WHERE name = @StandardName
	IF @BookId IS NOT NULL BEGIN
		RAISERROR('The book ''%s'' already exists so we are aborting.', 11, 1, @StandardName) -- Severity of 10 or lower WILL NOT BE HANDLED BY TRY/CATCH
	END

	INSERT INTO book (name, isbn, date_published, pub_accuracy_id, number_pages, subtitle, book_type_id, book_subtype_id) 
	VALUES (@StandardName, @IsbnPaperback, @DatePublished, @DateAccuracyIdDay, @NumberPages, @Subtitle, @BookTypeIdTechnology, @BookSubtypeIdUncategorized)
	SET @BookId = SCOPE_IDENTITY()

	INSERT INTO entity_list (entity_table_id, related_id, list_id, category_id, sort_order, start_accuracy_id, end_accuracy_id)
	VALUES(@EntityTableIdBook, @BookId, @EntityTypeId, @EntityCategoryIdTechnology, @DisplayOrderDefault, @DateAccuracyIdYear, @DateAccuracyIdYear)

	IF @StandardName != '' BEGIN
		EXEC ##InsertName 
			@Name = @StandardName, 
			@Alphabetic = @StandardAlphabetic,
			@Wikipedia = @Wikipedia,
			@NameType = 'StandardName', 
			@EntityTableId = @EntityTableIdBook, 
			@RelatedId = @BookId, 
			@NameTypeId = @NameTypeIdFull, 
			@NameSubtypeId = @NameSubtypeIdStandard, 
			@SortOrder = @DisplayOrderDefault,
			@DataDate = @DataDate,
			@DataType = @DataType
	END

	IF @OtherName1 != '' BEGIN
		EXEC ##InsertName 
			@Name = @OtherName1, 
			@Alphabetic = @OtherAlphabetic1,
			@NameType = 'OtherName1', 
			@EntityTableId = @EntityTableIdBook, 
			@RelatedId = @BookId, 
			@NameTypeId = @NameTypeIdFull, 
			@NameSubtypeId = @NameSubtypeIdOther, 
			@SortOrder = @DisplayOrderDefault
	END

	IF @OtherName2 != '' BEGIN
		EXEC ##InsertName 
			@Name = @OtherName2, 
			@Alphabetic = @OtherAlphabetic2,
			@NameType = 'OtherName2', 
			@EntityTableId = @EntityTableIdBook, 
			@RelatedId = @BookId, 
			@NameTypeId = @NameTypeIdFull, 
			@NameSubtypeId = @NameSubtypeIdOther, 
			@SortOrder = @DisplayOrderDefault
	END

	IF @OtherName3 != '' BEGIN
		EXEC ##InsertName 
			@Name = @OtherName3, 
			@Alphabetic = @OtherAlphabetic3,
			@NameType = 'OtherName3', 
			@EntityTableId = @EntityTableIdBook, 
			@RelatedId = @BookId, 
			@NameTypeId = @NameTypeIdFull, 
			@NameSubtypeId = @NameSubtypeIdOther, 
			@SortOrder = @DisplayOrderDefault
	END

	IF @HomeUrl != '' BEGIN
		EXEC ##InsertUrl 
			@Url = @HomeUrl, 
			@EntityTableId = @EntityTableIdBook, 
			@RelatedId = @BookId, 
			@UrlTypeId = @UrlTypeIdHome, 
			@CompanyId = NULL, 
			@UrlName = NULL, 
			@SortOrder = 1
	END

	IF @AmazonUrl != '' BEGIN
		EXEC ##InsertUrl 
			@Url = @AmazonUrl, 
			@EntityTableId = @EntityTableIdBook, 
			@RelatedId = @BookId, 
			@UrlTypeId = @UrlTypeIdOther, 
			@CompanyId = @CompanyIdAmazon, 
			@UrlName = NULL, 
			@SortOrder = 10
	END

	IF @IsbnPaperback IS NOT NULL BEGIN
		EXEC ##InsertBookNumber 
			@Isbn = @IsbnPaperback, 
			@Isbn10 = @IsbnPaperback10, 
			@BookId = @BookId, 
			@BookNumberTypeId = @BookNumberTypeIdIsbn, 
			@BookNumberSubtypeId = @BookNumberSubtypeIdPaperback, 
			@PublicationDate = NULL, 
			@DateAccuracyId = NULL
	END

	IF @IsbnDigital IS NOT NULL BEGIN
		EXEC ##InsertBookNumber 
			@Isbn = @IsbnDigital, 
			@Isbn10 = @IsbnDigital10, 
			@BookId = @BookId, 
			@BookNumberTypeId = @BookNumberTypeIdIsbn, 
			@BookNumberSubtypeId = @BookNumberSubtypeIdDigital, 
			@PublicationDate = NULL, 
			@DateAccuracyId = NULL
	END

	-- Publisher's Description
	EXEC ##InsertNote 
		@DailyDate = @DailyDate, 
		@EntityTableID = @EntityTableIdBook, 
		@RelatedId = @BookId, 
		@NoteTypeId = @NoteTypeIdDescription, 
		@SortOrder = 1

	-- Book Image
	EXEC ##InsertNote 
		@DailyDate = @DailyDate, 
		@EntityTableID = @EntityTableIdBook, 
		@RelatedId = @BookId, 
		@NoteTypeId = @NoteTypeIdImage, 
		@SortOrder = 2

	-- Twitter Image Tags
	EXEC ##InsertNote 
		@DailyDate = @DailyDate, 
		@EntityTableID = @EntityTableIdBook, 
		@RelatedId = @BookId, 
		@NoteTypeId = @NoteTypeIdTwitterImageTags, 
		@SortOrder = 3

	-- Brief
	EXEC ##InsertNote 
		@DailyDate = @DailyDate, 
		@EntityTableID = @EntityTableIdBook, 
		@RelatedId = @BookId, 
		@NoteTypeId = @NoteTypeIdBrief, 
		@SortOrder = 4

	-- Twitter {@DailyDate}
	EXEC ##InsertNote 
		@DailyDate = @DailyDate, 
		@EntityTableID = @EntityTableIdBook, 
		@RelatedId = @BookId, 
		@NoteTypeId = @NoteTypeIdTwitter, 
		@SortOrder = 101

	-- Tweet {@DailyDate}
	EXEC ##InsertNote 
		@DailyDate = @DailyDate, 
		@EntityTableID = @EntityTableIdBook, 
		@RelatedId = @BookId, 
		@NoteTypeId = @NoteTypeIdTweet, 
		@SortOrder = 102


	COMMIT TRANSACTION
	PRINT 'Transaction committed'
END TRY

BEGIN CATCH
	ROLLBACK TRANSACTION;
	PRINT 'Transaction Rolled Back: Error ' + CAST(ERROR_NUMBER() AS VARCHAR) + ' on line ' + CAST(ERROR_LINE() AS VARCHAR) + ': ' + ERROR_MESSAGE();

END CATCH

SET NOCOUNT OFF

SELECT * FROM book WHERE name = @StandardName

/*
SELECT TOP 10 * FROM unique_name ORDER BY 1 DESC
SELECT TOP 10 * FROM book ORDER BY 1 DESC
SELECT TOP 10 * FROM entity_list WHERE entity_table_id = 50001 ORDER BY 1 DESC -- related thing_type
SELECT TOP 10 * FROM name ORDER BY 1 DESC
SELECT TOP 10 * FROM name_data ORDER BY 1 DESC
SELECT TOP 10 * FROM url ORDER BY 1 DESC
SELECT TOP 10 * FROM book_number ORDER BY 1 DESC
SELECT TOP 40 * FROM note ORDER BY 1 DESC

SELECT * FROM person WHERE name = 'Ned Bellavance'
*/

/*
SELECT TOP 10 * FROM unique_name ORDER BY 1 DESC

*/

/*

-- Fix issue with Vandad Nahavandipoor record
INSERT INTO name (unique_name_id, entity_table_id, related_id, type_id, subtype_id, display_order) 
VALUES (170396, 1, 77078, 1001, 2001, 9999)

*/

/* Empty Parameters
DECLARE @StandardName VARCHAR(255) = 'TITLE', @StandardAlphabetic VARCHAR(255) = 'TITLE',
		@DailyDate VARCHAR(20) = '2017.10.03',
		@EntityType VARCHAR(10) = 'Book',
		@IsbnPaperback VARCHAR(30) = 'NULL', @IsbnPaperback10 VARCHAR(30) = 'NULL',
		@IsbnDigital VARCHAR(30) = 'NULL', @IsbnDigital10 VARCHAR(30) = 'NULL',
		@HomeUrl VARCHAR(255) = '', @AmazonUrl VARCHAR(255) = '',
		@NumberPages INT = 0,
		@DatePublished DATETIME = '',
		@DataDate VARCHAR(50) = '', @DataType VARCHAR(50) = '',
		@Subtitle VARCHAR(255) = '',
		@Wikipedia VARCHAR(75) = '',
		@OtherName1 VARCHAR(255) = '', @OtherAlphabetic1 VARCHAR(255) = '',
		@OtherName2 VARCHAR(255) = '', @OtherAlphabetic2 VARCHAR(255) = '',
		@OtherName3 VARCHAR(255) = '', @OtherAlphabetic3 VARCHAR(255) = ''


*/