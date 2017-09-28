USE illustrated2
GO

DECLARE @StandardName VARCHAR(255) = '',
		@StandardAlphabetic VARCHAR(255) = '',
		@Wikipedia VARCHAR(75) = NULL,
		@DataDate VARCHAR(50) = NULL,
		@DataType VARCHAR(50) = NULL,
		@OtherName1 VARCHAR(255) = '',
		@OtherAlphabetic1 VARCHAR(255) = '',
		@OtherName2 VARCHAR(255) = '',
		@OtherAlphabetic2 VARCHAR(255) = '',
		@OtherName3 VARCHAR(255) = '',
		@OtherAlphabetic3 VARCHAR(255) = '',
		@OtherName4 VARCHAR(255) = '',
		@OtherAlphabetic4 VARCHAR(255) = '',
		@HomeUrl VARCHAR(255) = '',
		@BlogUrl VARCHAR(255) = '',
		@TwitterUrl VARCHAR(255) = '',
		@GitHubUrl VARCHAR(255) = '',
		@LinkedInUrl VARCHAR(255) = '',
		@YouTubeUrl VARCHAR(255) = '',
		@GooglePlusUrl VARCHAR(255) = '',
		@InstagramUrl VARCHAR(255) = '',
		@FaceBookUrl VARCHAR(255) = '',
		@StackOverflowUrl VARCHAR(255) = '',
		@MediumUrl VARCHAR(255) = '',
		@PluralsightUrl VARCHAR(255) = ''

-- Constants
DECLARE @EntityTableIdThing INT = 50001, @ThingTypeIdTechnology INT = 151025
DECLARE @NameTypeIdFull INT = 1001, @NameTypeIdPart INT = 1002
DECLARE @NameSubtypeIdStandard INT = 2001, @NameSubtypeIdOther INT = 2004
DECLARE @NameSubtypeIdLookup INT = 2019
DECLARE @EntityTypeIdTechnology INT = 151027, @EntityCategoryIdTechnology INT = 151026, @DateAccuracyIdYear INT = 100023
DECLARE @DisplayOrderDefault INT = 9999, @DataMissing VARCHAR(20) = '????', @Technology VARCHAR(20) = 'Technology', @PrimaryIdEmpty INT = 19636
DECLARE @UrlTypeIdHome INT = 28004, @UrlTypeIdSocial INT = 150715, @UrlTypeIdOther INT = 28005, @UrlTypeIdBlog INT = 28010
DECLARE @CompanyIdTwitter INT = 51528, @CompanyIdGitHub INT = 51757, @CompanyIdLinkedIn INT = 51541, @CompanyIdFacebook INT = 51304, @CompanyIdPluralsight INT = 51768
DECLARE @CompanyIdYouTube INT = 51099, @CompanyIdMedium INT = 51762, @CompanyIdGooglePlus INT = 51765, @CompanyIdInstagram INT = 51755, @CompanyIdStackOverflow INT = 51773

-- Variables
DECLARE @UniqueNameId INT, @NameId INT, @ThingId INT, @FullName VARCHAR(255), @FullAlphabetic VARCHAR(255)

SET NOCOUNT ON

BEGIN TRANSACTION

BEGIN TRY
	SELECT @ThingId = thing_id FROM thing WHERE name = @StandardName
	IF @ThingId IS NOT NULL BEGIN
		RAISERROR('The thing ''%s'' already exists so we are aborting.', 11, 1, @StandardName) -- Severity of 10 or lower WILL NOT BE HANDLED BY TRY/CATCH
	END

	INSERT INTO thing (thing_type_id, name) VALUES (@ThingTypeIdTechnology, @StandardName)
	SET @ThingId = SCOPE_IDENTITY()

	INSERT INTO entity_list (entity_table_id, related_id, list_id, category_id, sort_order, start_accuracy_id, end_accuracy_id)
	VALUES(@EntityTableIdThing, @ThingId, @EntityTypeIdTechnology, @EntityCategoryIdTechnology, @DisplayOrderDefault, @DateAccuracyIdYear, @DateAccuracyIdYear)

	IF @StandardName != '' BEGIN
		EXEC ##InsertName 
			@Name = @StandardName, 
			@Alphabetic = @StandardAlphabetic,
			@Wikipedia = @Wikipedia,
			@DataDate = @DataDate,
			@DataType = @DataType,
			@NameType = 'StandardName', 
			@EntityTableId = @EntityTableIdThing, 
			@RelatedId = @ThingId, 
			@NameTypeId = @NameTypeIdFull, 
			@NameSubtypeId = @NameSubtypeIdStandard, 
			@SortOrder = @DisplayOrderDefault
	END

	IF @OtherName1 != '' BEGIN
		EXEC ##InsertName 
			@Name = @OtherName1, 
			@Alphabetic = @OtherAlphabetic1,
			@NameType = 'OtherName1', 
			@EntityTableId = @EntityTableIdThing, 
			@RelatedId = @ThingId, 
			@NameTypeId = @NameTypeIdFull, 
			@NameSubtypeId = @NameSubtypeIdOther, 
			@SortOrder = @DisplayOrderDefault
	END

	IF @OtherName2 != '' BEGIN
		EXEC ##InsertName 
			@Name = @OtherName2, 
			@Alphabetic = @OtherAlphabetic2,
			@NameType = 'OtherName2', 
			@EntityTableId = @EntityTableIdThing, 
			@RelatedId = @ThingId, 
			@NameTypeId = @NameTypeIdFull, 
			@NameSubtypeId = @NameSubtypeIdOther, 
			@SortOrder = @DisplayOrderDefault
	END

	IF @OtherName3 != '' BEGIN
		EXEC ##InsertName 
			@Name = @OtherName3, 
			@Alphabetic = @OtherAlphabetic3,
			@NameType = 'OtherName3', 
			@EntityTableId = @EntityTableIdThing, 
			@RelatedId = @ThingId, 
			@NameTypeId = @NameTypeIdFull, 
			@NameSubtypeId = @NameSubtypeIdOther, 
			@SortOrder = @DisplayOrderDefault
	END

	IF @OtherName4 != '' BEGIN
		EXEC ##InsertName 
			@Name = @OtherName4, 
			@Alphabetic = @OtherAlphabetic4,
			@NameType = 'OtherName4', 
			@EntityTableId = @EntityTableIdThing, 
			@RelatedId = @ThingId, 
			@NameTypeId = @NameTypeIdFull, 
			@NameSubtypeId = @NameSubtypeIdOther, 
			@SortOrder = @DisplayOrderDefault
	END

	IF @HomeUrl != '' BEGIN
		EXEC ##InsertUrl 
			@Url = @HomeUrl, 
			@EntityTableId = @EntityTableIdThing, 
			@RelatedId = @ThingId, 
			@UrlTypeId = @UrlTypeIdHome, 
			@CompanyId = NULL, 
			@UrlName = NULL, 
			@SortOrder = 1
	END

	IF @BlogUrl != '' BEGIN
		EXEC ##InsertUrl 
			@Url = @BlogUrl, 
			@EntityTableId = @EntityTableIdThing, 
			@RelatedId = @ThingId, 
			@UrlTypeId = @UrlTypeIdBlog, 
			@CompanyId = NULL, 
			@UrlName = NULL, 
			@SortOrder = 2
	END

	IF @TwitterUrl != '' BEGIN
		EXEC ##InsertUrl 
			@Url = @TwitterUrl, 
			@EntityTableId = @EntityTableIdThing, 
			@RelatedId = @ThingId, 
			@UrlTypeId = @UrlTypeIdSocial, 
			@CompanyId = @CompanyIdTwitter, 
			@UrlName = NULL, 
			@SortOrder = 10
	END

	IF @GitHubUrl != '' BEGIN
		EXEC ##InsertUrl 
			@Url = @GitHubUrl, 
			@EntityTableId = @EntityTableIdThing, 
			@RelatedId = @ThingId, 
			@UrlTypeId = @UrlTypeIdSocial, 
			@CompanyId = @CompanyIdGitHub, 
			@UrlName = NULL, 
			@SortOrder = 11
	END

	IF @LinkedInUrl != '' BEGIN
		EXEC ##InsertUrl 
			@Url = @LinkedInUrl, 
			@EntityTableId = @EntityTableIdThing, 
			@RelatedId = @ThingId, 
			@UrlTypeId = @UrlTypeIdSocial, 
			@CompanyId = @CompanyIdLinkedIn, 
			@UrlName = NULL, 
			@SortOrder = 12
	END

	IF @YouTubeUrl != '' BEGIN
		EXEC ##InsertUrl 
			@Url = @YouTubeUrl, 
			@EntityTableId = @EntityTableIdThing, 
			@RelatedId = @ThingId, 
			@UrlTypeId = @UrlTypeIdSocial, 
			@CompanyId = @CompanyIdYouTube, 
			@UrlName = NULL, 
			@SortOrder = 13
	END

	IF @GooglePlusUrl != '' BEGIN
		EXEC ##InsertUrl 
			@Url = @GooglePlusUrl, 
			@EntityTableId = @EntityTableIdThing, 
			@RelatedId = @ThingId, 
			@UrlTypeId = @UrlTypeIdSocial, 
			@CompanyId = @CompanyIdGooglePlus, 
			@UrlName = NULL, 
			@SortOrder = 14
	END

	IF @InstagramUrl != '' BEGIN
		EXEC ##InsertUrl 
			@Url = @InstagramUrl, 
			@EntityTableId = @EntityTableIdThing, 
			@RelatedId = @ThingId, 
			@UrlTypeId = @UrlTypeIdSocial, 
			@CompanyId = @CompanyIdInstagram, 
			@UrlName = NULL, 
			@SortOrder = 15
	END

	IF @FaceBookUrl != '' BEGIN
		EXEC ##InsertUrl 
			@Url = @FaceBookUrl, 
			@EntityTableId = @EntityTableIdThing, 
			@RelatedId = @ThingId, 
			@UrlTypeId = @UrlTypeIdSocial, 
			@CompanyId = @CompanyIdFacebook, 
			@UrlName = NULL, 
			@SortOrder = 16
	END

	IF @StackOverflowUrl != '' BEGIN
		EXEC ##InsertUrl 
			@Url = @StackOverflowUrl, 
			@EntityTableId = @EntityTableIdThing, 
			@RelatedId = @ThingId, 
			@UrlTypeId = @UrlTypeIdSocial, 
			@CompanyId = @CompanyIdStackOverflow, 
			@UrlName = NULL, 
			@SortOrder = 20
	END

	IF @MediumUrl != '' BEGIN
		EXEC ##InsertUrl 
			@Url = @MediumUrl, 
			@EntityTableId = @EntityTableIdThing, 
			@RelatedId = @ThingId, 
			@UrlTypeId = @UrlTypeIdSocial, 
			@CompanyId = @CompanyIdMedium, 
			@UrlName = NULL, 
			@SortOrder = 21
	END

	IF @PluralsightUrl != '' BEGIN
		EXEC ##InsertUrl 
			@Url = @PluralsightUrl, 
			@EntityTableId = @EntityTableIdThing, 
			@RelatedId = @ThingId, 
			@UrlTypeId = @UrlTypeIdOther, 
			@CompanyId = @CompanyIdPluralsight, 
			@UrlName = NULL, 
			@SortOrder = 22
	END

	COMMIT TRANSACTION
	PRINT 'Transaction committed'
END TRY

BEGIN CATCH
	ROLLBACK TRANSACTION;
	PRINT 'Transaction Rolled Back: Error ' + CAST(ERROR_NUMBER() AS VARCHAR) + ' on line ' + CAST(ERROR_LINE() AS VARCHAR) + ': ' + ERROR_MESSAGE();

END CATCH

SET NOCOUNT OFF

/*
SELECT TOP 10 * FROM unique_name ORDER BY 1 DESC
SELECT TOP 10 * FROM thing ORDER BY 1 DESC
SELECT TOP 10 * FROM entity_list WHERE entity_table_id = 50001 ORDER BY 1 DESC -- related thing_type
SELECT TOP 10 * FROM name ORDER BY 1 DESC
SELECT TOP 10 * FROM name_data ORDER BY 1 DESC
SELECT TOP 10 * FROM url ORDER BY 1 DESC

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
DECLARE @StandardName VARCHAR(255) = '',
		@StandardAlphabetic VARCHAR(255) = '',
		@Wikipedia VARCHAR(75) = NULL,
		@DataDate VARCHAR(50) = NULL,
		@DataType VARCHAR(50) = NULL,
		@OtherName1 VARCHAR(255) = '',
		@OtherAlphabetic1 VARCHAR(255) = '',
		@OtherName2 VARCHAR(255) = '',
		@OtherAlphabetic2 VARCHAR(255) = '',
		@OtherName3 VARCHAR(255) = '',
		@OtherAlphabetic3 VARCHAR(255) = '',
		@OtherName4 VARCHAR(255) = '',
		@OtherAlphabetic4 VARCHAR(255) = '',
		@HomeUrl VARCHAR(255) = '',
		@BlogUrl VARCHAR(255) = '',
		@TwitterUrl VARCHAR(255) = '',
		@GitHubUrl VARCHAR(255) = '',
		@LinkedInUrl VARCHAR(255) = '',
		@YouTubeUrl VARCHAR(255) = '',
		@GooglePlusUrl VARCHAR(255) = '',
		@InstagramUrl VARCHAR(255) = '',
		@FaceBookUrl VARCHAR(255) = '',
		@StackOverflowUrl VARCHAR(255) = '',
		@MediumUrl VARCHAR(255) = '',
		@PluralsightUrl VARCHAR(255) = ''

*/