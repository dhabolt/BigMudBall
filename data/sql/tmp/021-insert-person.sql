USE illustrated2
GO

DECLARE @FullName1 VARCHAR(255) = 'FIRST LAST', @Alphabetic1 VARCHAR(255) = 'LAST, FIRST',
		@FirstName VARCHAR(60) = 'FIRST', @LastName VARCHAR(60) = 'LAST', @MiddleName VARCHAR(60) = '',
		@FullNameOther VARCHAR(255) = '', @AlphabeticOther VARCHAR(255) = '',
		@FullNameOther2 VARCHAR(255) = '', @AlphabeticOther2 VARCHAR(255) = '',
		@FullNameOther3 VARCHAR(255) = '', @AlphabeticOther3 VARCHAR(255) = '',
		@FirstName2 VARCHAR(60) = '', @FirstName3 VARCHAR(60) = '', @FirstName4 VARCHAR(60) = '',
		@LastName2 VARCHAR(60) = '', @LastName3 VARCHAR(60) = '', @LastName4 VARCHAR(60) = '',
		@DataDate VARCHAR(50) = '', @DataType VARCHAR(50) = '',
		@UniqueAdd VARCHAR(60) = NULL, -- person.unique_add
		@HomeUrl VARCHAR(255) = '',
		@BlogUrl VARCHAR(255) = '',
		@TwitterUrl VARCHAR(255) = '',
		@GitHubUrl VARCHAR(255) = '',
		@LinkedInUrl VARCHAR(255) = '',
		@YouTubeUrl VARCHAR(255) = '',
		@GooglePlusUrl VARCHAR(255) = '',
		@InstagramUrl VARCHAR(255) = '',
		@FaceBookUrl VARCHAR(255) = '',
		@FlickrUrl VARCHAR(255) = '',
		@PinterestUrl VARCHAR(255) = '',
		@StackOverflowUrl VARCHAR(255) = '',
		@CrunchbaseUrl VARCHAR(255) = '',
		@MediumUrl VARCHAR(255) = '',
		@PluralsightUrl VARCHAR(255) = '',
		@SlideShareUrl VARCHAR(255) = '', 
		@QuoraUrl VARCHAR(255) = '', 
		@RedditUrl VARCHAR(255) = ''

-- Constants
DECLARE @EntityTablePersonId INT = 1
DECLARE @NameTypeFullId INT = 1001, @NameTypePartId INT = 1002
DECLARE @NameSubtypeStandardId INT = 2001, @NameSubtypeFirstId INT = 2008, @NameSubtypeLastId INT = 2009, @NameSubtypeFormalId INT = 2002, @NameSubtypeOtherId INT = 2004, @NameSubtypeMiddleId INT = 2010
DECLARE @NameSubtypeLookupId INT = 2019
DECLARE @EntityTypeTechnologyId INT = 151027, @EntityCategoryTechnologyId INT = 151026, @DateAccuracyYearId INT = 100023
DECLARE @DisplayOrderDefault INT = 9999, @DataMissing VARCHAR(20) = '????', @Technology VARCHAR(20) = 'Technology', @PrimaryIdEmpty INT = 19636
DECLARE @UrlTypeIdHome INT = 28004, @UrlTypeIdSocial INT = 150715, @UrlTypeIdOther INT = 28005, @UrlTypeIdBlog INT = 28010
DECLARE @CompanyIdTwitter INT = 51528, @CompanyIdGitHub INT = 51757, @CompanyIdLinkedIn INT = 51541, @CompanyIdFacebook INT = 51304, @CompanyIdPluralsight INT = 51768
DECLARE @CompanyIdYouTube INT = 51099, @CompanyIdMedium INT = 51762, @CompanyIdGooglePlus INT = 51765, @CompanyIdInstagram INT = 51755, @CompanyIdStackOverflow INT = 51773
DECLARE @CompanyIdFlickr INT = 51545, @CompanyIdPinterest INT = 51759, @CompanyIdSlideShare INT = 51764, @CompanyIdQuora INT = 51767, @CompanyIdReddit INT = 51760
DECLARE @CompanyIdCrunchbase INT = 51777

-- Variables
DECLARE @UniqueNameId INT, @NameId INT, @PersonId INT, @FullName VARCHAR(255), @FullAlphabetic VARCHAR(255)

SET NOCOUNT ON

BEGIN TRANSACTION

BEGIN TRY
	SELECT @PersonId = person_id FROM person WHERE name = @FullName1 AND unique_add = @UniqueAdd
	IF @PersonId IS NOT NULL BEGIN
		RAISERROR('The person already exists so we are aborting. Use the unique_add if we need to create a unique person.', 11, 1) -- Severity of 10 or lower WILL NOT BE HANDLED BY TRY/CATCH
	END

	INSERT INTO person (name, unique_add) VALUES (@FullName1, @UniqueAdd)
	SET @PersonId = SCOPE_IDENTITY()

	INSERT INTO entity_list (entity_table_id, related_id, list_id, category_id, sort_order, start_accuracy_id, end_accuracy_id)
	VALUES(@EntityTablePersonId, @PersonId, @EntityTypeTechnologyId, @EntityCategoryTechnologyId, @DisplayOrderDefault, @DateAccuracyYearId, @DateAccuracyYearId)

	IF @FullName1 != '' BEGIN
		EXEC ##InsertName 
			@Name = @FullName1, 
			@Alphabetic = @Alphabetic1,
			@NameType = 'FullName1', 
			@EntityTableId = @EntityTablePersonId, 
			@RelatedId = @PersonId, 
			@NameTypeId = @NameTypeFullId, 
			@NameSubtypeId = @NameSubtypeStandardId, 
			@SortOrder = @DisplayOrderDefault
	END

	IF @FullNameOther != '' BEGIN
		EXEC ##InsertName 
			@Name = @FullNameOther, 
			@Alphabetic = @AlphabeticOther,
			@NameType = 'FullNameOther', 
			@NameTypeId = @NameTypeFullId, 
			@NameSubtypeId = @NameSubtypeOtherId, 
			@EntityTableId = @EntityTablePersonId, 
			@RelatedId = @PersonId, 
			@SortOrder = @DisplayOrderDefault
	END

	IF @FullNameOther2 != '' BEGIN
		EXEC ##InsertName 
			@Name = @FullNameOther2, 
			@Alphabetic = @AlphabeticOther2,
			@NameType = 'FullNameOther2', 
			@NameTypeId = @NameTypeFullId, 
			@NameSubtypeId = @NameSubtypeOtherId, 
			@EntityTableId = @EntityTablePersonId, 
			@RelatedId = @PersonId, 
			@SortOrder = @DisplayOrderDefault
	END

	IF @FullNameOther3 != '' BEGIN
		EXEC ##InsertName 
			@Name = @FullNameOther3, 
			@Alphabetic = @AlphabeticOther3,
			@NameType = 'FullNameOther3', 
			@NameTypeId = @NameTypeFullId, 
			@NameSubtypeId = @NameSubtypeOtherId, 
			@EntityTableId = @EntityTablePersonId, 
			@RelatedId = @PersonId, 
			@SortOrder = @DisplayOrderDefault
	END

	IF @FirstName != '' BEGIN
		EXEC ##InsertName 
			@Name = @FirstName, 
			@Alphabetic = @FirstName,
			@NameType = 'FirstName', 
			@NameTypeId = @NameTypePartId, 
			@NameSubtypeId = @NameSubtypeFirstId, 
			@EntityTableId = @EntityTablePersonId, 
			@RelatedId = @PersonId, 
			@SortOrder = @DisplayOrderDefault
	END

	IF @FirstName2 != '' BEGIN
		EXEC ##InsertName 
			@Name = @FirstName2, 
			@Alphabetic = @FirstName2,
			@NameType = 'FirstName2', 
			@NameTypeId = @NameTypePartId, 
			@NameSubtypeId = @NameSubtypeFirstId, 
			@EntityTableId = @EntityTablePersonId, 
			@RelatedId = @PersonId, 
			@SortOrder = @DisplayOrderDefault
	END

	IF @FirstName3 != '' BEGIN
		EXEC ##InsertName 
			@Name = @FirstName3, 
			@Alphabetic = @FirstName3,
			@NameType = 'FirstName3', 
			@NameTypeId = @NameTypePartId, 
			@NameSubtypeId = @NameSubtypeFirstId, 
			@EntityTableId = @EntityTablePersonId, 
			@RelatedId = @PersonId, 
			@SortOrder = @DisplayOrderDefault
	END

	IF @FirstName4 != '' BEGIN
		EXEC ##InsertName 
			@Name = @FirstName4, 
			@Alphabetic = @FirstName4,
			@NameType = 'FirstName4', 
			@NameTypeId = @NameTypePartId, 
			@NameSubtypeId = @NameSubtypeFirstId, 
			@EntityTableId = @EntityTablePersonId, 
			@RelatedId = @PersonId, 
			@SortOrder = @DisplayOrderDefault
	END

	IF @LastName != '' BEGIN
		EXEC ##InsertName 
			@Name = @LastName, 
			@Alphabetic = @LastName,
			@NameType = 'LastName', 
			@NameTypeId = @NameTypePartId, 
			@NameSubtypeId = @NameSubtypeLastId, 
			@EntityTableId = @EntityTablePersonId, 
			@RelatedId = @PersonId, 
			@SortOrder = @DisplayOrderDefault
	END

	IF @LastName2 != '' BEGIN
		EXEC ##InsertName 
			@Name = @LastName2, 
			@Alphabetic = @LastName2,
			@NameType = 'LastName2', 
			@NameTypeId = @NameTypePartId, 
			@NameSubtypeId = @NameSubtypeLastId, 
			@EntityTableId = @EntityTablePersonId, 
			@RelatedId = @PersonId, 
			@SortOrder = @DisplayOrderDefault
	END

	IF @LastName3 != '' BEGIN
		EXEC ##InsertName 
			@Name = @LastName3, 
			@Alphabetic = @LastName3,
			@NameType = 'LastName3', 
			@NameTypeId = @NameTypePartId, 
			@NameSubtypeId = @NameSubtypeLastId, 
			@EntityTableId = @EntityTablePersonId, 
			@RelatedId = @PersonId, 
			@SortOrder = @DisplayOrderDefault
	END

	IF @LastName4 != '' BEGIN
		EXEC ##InsertName 
			@Name = @LastName4, 
			@Alphabetic = @LastName4,
			@NameType = 'LastName4', 
			@NameTypeId = @NameTypePartId, 
			@NameSubtypeId = @NameSubtypeLastId, 
			@EntityTableId = @EntityTablePersonId, 
			@RelatedId = @PersonId, 
			@SortOrder = @DisplayOrderDefault
	END

	IF @MiddleName != '' BEGIN
		EXEC ##InsertName 
			@Name = @MiddleName, 
			@Alphabetic = @MiddleName,
			@NameType = 'MiddleName', 
			@NameTypeId = @NameTypePartId, 
			@NameSubtypeId = @NameSubtypeMiddleId, 
			@EntityTableId = @EntityTablePersonId, 
			@RelatedId = @PersonId, 
			@SortOrder = @DisplayOrderDefault
	END

	IF @HomeUrl != '' BEGIN
		EXEC ##InsertUrl 
			@Url = @HomeUrl, 
			@EntityTableId = @EntityTablePersonId, 
			@RelatedId = @PersonId, 
			@UrlTypeId = @UrlTypeIdHome, 
			@CompanyId = NULL, 
			@UrlName = NULL, 
			@SortOrder = 1
	END

	IF @BlogUrl != '' BEGIN
		EXEC ##InsertUrl 
			@Url = @BlogUrl, 
			@EntityTableId = @EntityTablePersonId, 
			@RelatedId = @PersonId, 
			@UrlTypeId = @UrlTypeIdBlog, 
			@CompanyId = NULL, 
			@UrlName = NULL, 
			@SortOrder = 2
	END

	IF @TwitterUrl != '' BEGIN
		EXEC ##InsertUrl 
			@Url = @TwitterUrl, 
			@EntityTableId = @EntityTablePersonId, 
			@RelatedId = @PersonId, 
			@UrlTypeId = @UrlTypeIdSocial, 
			@CompanyId = @CompanyIdTwitter, 
			@UrlName = NULL, 
			@SortOrder = 10
	END

	IF @GitHubUrl != '' BEGIN
		EXEC ##InsertUrl 
			@Url = @GitHubUrl, 
			@EntityTableId = @EntityTablePersonId, 
			@RelatedId = @PersonId, 
			@UrlTypeId = @UrlTypeIdSocial, 
			@CompanyId = @CompanyIdGitHub, 
			@UrlName = NULL, 
			@SortOrder = 11
	END

	IF @LinkedInUrl != '' BEGIN
		EXEC ##InsertUrl 
			@Url = @LinkedInUrl, 
			@EntityTableId = @EntityTablePersonId, 
			@RelatedId = @PersonId, 
			@UrlTypeId = @UrlTypeIdSocial, 
			@CompanyId = @CompanyIdLinkedIn, 
			@UrlName = NULL, 
			@SortOrder = 12
	END

	IF @YouTubeUrl != '' BEGIN
		EXEC ##InsertUrl 
			@Url = @YouTubeUrl, 
			@EntityTableId = @EntityTablePersonId, 
			@RelatedId = @PersonId, 
			@UrlTypeId = @UrlTypeIdSocial, 
			@CompanyId = @CompanyIdYouTube, 
			@UrlName = NULL, 
			@SortOrder = 13
	END

	IF @GooglePlusUrl != '' BEGIN
		EXEC ##InsertUrl 
			@Url = @GooglePlusUrl, 
			@EntityTableId = @EntityTablePersonId, 
			@RelatedId = @PersonId, 
			@UrlTypeId = @UrlTypeIdSocial, 
			@CompanyId = @CompanyIdGooglePlus, 
			@UrlName = NULL, 
			@SortOrder = 14
	END

	IF @InstagramUrl != '' BEGIN
		EXEC ##InsertUrl 
			@Url = @InstagramUrl, 
			@EntityTableId = @EntityTablePersonId, 
			@RelatedId = @PersonId, 
			@UrlTypeId = @UrlTypeIdSocial, 
			@CompanyId = @CompanyIdInstagram, 
			@UrlName = NULL, 
			@SortOrder = 15
	END

	IF @FaceBookUrl != '' BEGIN
		EXEC ##InsertUrl 
			@Url = @FaceBookUrl, 
			@EntityTableId = @EntityTablePersonId, 
			@RelatedId = @PersonId, 
			@UrlTypeId = @UrlTypeIdSocial, 
			@CompanyId = @CompanyIdFacebook, 
			@UrlName = NULL, 
			@SortOrder = 16
	END

	IF @FlickrUrl != '' BEGIN
		EXEC ##InsertUrl 
			@Url = @FlickrUrl, 
			@EntityTableId = @EntityTablePersonId, 
			@RelatedId = @PersonId, 
			@UrlTypeId = @UrlTypeIdSocial, 
			@CompanyId = @CompanyIdFlickr, 
			@UrlName = NULL, 
			@SortOrder = 17
	END

	IF @PinterestUrl != '' BEGIN
		EXEC ##InsertUrl 
			@Url = @PinterestUrl, 
			@EntityTableId = @EntityTablePersonId, 
			@RelatedId = @PersonId, 
			@UrlTypeId = @UrlTypeIdSocial, 
			@CompanyId = @CompanyIdPinterest, 
			@UrlName = NULL, 
			@SortOrder = 18
	END

	IF @CrunchbaseUrl != '' BEGIN
		EXEC ##InsertUrl 
			@Url = @CrunchbaseUrl, 
			@EntityTableId = @EntityTablePersonId, 
			@RelatedId = @PersonId, 
			@UrlTypeId = @UrlTypeIdSocial, 
			@CompanyId = @CompanyIdCrunchbase, 
			@UrlName = NULL, 
			@SortOrder = 19
	END

	IF @StackOverflowUrl != '' BEGIN
		EXEC ##InsertUrl 
			@Url = @StackOverflowUrl, 
			@EntityTableId = @EntityTablePersonId, 
			@RelatedId = @PersonId, 
			@UrlTypeId = @UrlTypeIdSocial, 
			@CompanyId = @CompanyIdStackOverflow, 
			@UrlName = NULL, 
			@SortOrder = 20
	END

	IF @MediumUrl != '' BEGIN
		EXEC ##InsertUrl 
			@Url = @MediumUrl, 
			@EntityTableId = @EntityTablePersonId, 
			@RelatedId = @PersonId, 
			@UrlTypeId = @UrlTypeIdSocial, 
			@CompanyId = @CompanyIdMedium, 
			@UrlName = NULL, 
			@SortOrder = 21
	END

	IF @PluralsightUrl != '' BEGIN
		EXEC ##InsertUrl 
			@Url = @PluralsightUrl, 
			@EntityTableId = @EntityTablePersonId, 
			@RelatedId = @PersonId, 
			@UrlTypeId = @UrlTypeIdOther, 
			@CompanyId = @CompanyIdPluralsight, 
			@UrlName = NULL, 
			@SortOrder = 22
	END

	IF @SlideShareUrl != '' BEGIN
		EXEC ##InsertUrl 
			@Url = @SlideShareUrl, 
			@EntityTableId = @EntityTablePersonId, 
			@RelatedId = @PersonId, 
			@UrlTypeId = @UrlTypeIdOther, 
			@CompanyId = @CompanyIdSlideShare, 
			@UrlName = NULL, 
			@SortOrder = 23
	END

	IF @QuoraUrl != '' BEGIN
		EXEC ##InsertUrl 
			@Url = @QuoraUrl, 
			@EntityTableId = @EntityTablePersonId, 
			@RelatedId = @PersonId, 
			@UrlTypeId = @UrlTypeIdOther, 
			@CompanyId = @CompanyIdQuora, 
			@UrlName = NULL, 
			@SortOrder = 24
	END

	IF @RedditUrl != '' BEGIN
		EXEC ##InsertUrl 
			@Url = @RedditUrl, 
			@EntityTableId = @EntityTablePersonId, 
			@RelatedId = @PersonId, 
			@UrlTypeId = @UrlTypeIdOther, 
			@CompanyId = @CompanyIdReddit, 
			@UrlName = NULL, 
			@SortOrder = 25
	END

	COMMIT TRANSACTION
	PRINT 'Transaction committed'
END TRY

BEGIN CATCH
	ROLLBACK TRANSACTION;
	PRINT 'Transaction Rolled Back: Error ' + CAST(ERROR_NUMBER() AS VARCHAR) + ' on line ' + CAST(ERROR_LINE() AS VARCHAR) + ': ' + ERROR_MESSAGE();

END CATCH

SET NOCOUNT OFF

SELECT person.* 
FROM person 
WHERE person_id = @PersonId

/*
SELECT TOP 10 * FROM unique_name ORDER BY 1 DESC
SELECT TOP 10 * FROM person ORDER BY 1 DESC
SELECT TOP 10 * FROM entity_list ORDER BY 1 DESC -- person_type
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
DECLARE @FullName1 VARCHAR(255) = 'FIRST LAST', @Alphabetic1 VARCHAR(255) = 'LAST, FIRST',
		@FirstName VARCHAR(60) = 'FIRST', @LastName VARCHAR(60) = 'LAST', @MiddleName VARCHAR(60) = '',
		@FullNameOther VARCHAR(255) = '', @AlphabeticOther VARCHAR(255) = '',
		@FullNameOther2 VARCHAR(255) = '', @AlphabeticOther2 VARCHAR(255) = '',
		@FullNameOther3 VARCHAR(255) = '', @AlphabeticOther3 VARCHAR(255) = '',
		@FirstName2 VARCHAR(60) = '', @FirstName3 VARCHAR(60) = '', @FirstName4 VARCHAR(60) = '',
		@LastName2 VARCHAR(60) = '', @LastName3 VARCHAR(60) = '', @LastName4 VARCHAR(60) = '',
		@DataDate VARCHAR(50) = '', @DataType VARCHAR(50) = '',
		@UniqueAdd VARCHAR(60) = NULL, -- person.unique_add
		@HomeUrl VARCHAR(255) = '',
		@BlogUrl VARCHAR(255) = '',
		@TwitterUrl VARCHAR(255) = '',
		@GitHubUrl VARCHAR(255) = '',
		@LinkedInUrl VARCHAR(255) = '',
		@YouTubeUrl VARCHAR(255) = '',
		@GooglePlusUrl VARCHAR(255) = '',
		@InstagramUrl VARCHAR(255) = '',
		@FaceBookUrl VARCHAR(255) = '',
		@FlickrUrl VARCHAR(255) = '',
		@PinterestUrl VARCHAR(255) = '',
		@StackOverflowUrl VARCHAR(255) = '',
		@CrunchbaseUrl VARCHAR(255) = '',
		@MediumUrl VARCHAR(255) = '',
		@PluralsightUrl VARCHAR(255) = '',
		@SlideShareUrl VARCHAR(255) = '', 
		@QuoraUrl VARCHAR(255) = '', 
		@RedditUrl VARCHAR(255) = ''

*/