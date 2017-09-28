USE illustrated2
GO

DECLARE @FullName1 VARCHAR(255) = 'FIRST LAST',
		@Alphabetic1 VARCHAR(255) = 'LAST, FIRST',
		@FullNameOther VARCHAR(255) = '',
		@AlphabeticOther VARCHAR(255) = '',
		@FirstName VARCHAR(60) = 'FIRST',
		@LastName VARCHAR(60) = 'LAST',
		@MiddleName VARCHAR(60) = '',
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
		@StackOverflowUrl VARCHAR(255) = '',
		@MediumUrl VARCHAR(255) = '',
		@PluralsightUrl VARCHAR(255) = ''

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

-- Variables
DECLARE @UniqueNameId INT, @NameId INT, @PersonId INT, @FullName VARCHAR(255), @FullAlphabetic VARCHAR(255)

SET NOCOUNT ON

BEGIN TRANSACTION

BEGIN TRY
	SELECT @PersonId FROM person WHERE name = @FullName1 AND unique_add = @UniqueAdd
	IF @PersonId IS NOT NULL BEGIN
		RAISERROR('The person already exists so we are aborting. Use the unique_add if we need to create a unique person.', 11, 1) -- Severity of 10 or lower WILL NOT BE HANDLED BY TRY/CATCH
	END

	INSERT INTO person (name) VALUES (@FullName1)
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
DECLARE @FullName1 VARCHAR(255) = 'FIRST LAST',
		@Alphabetic1 VARCHAR(255) = 'LAST, FIRST',
		@FullNameOther VARCHAR(255) = '',
		@AlphabeticOther VARCHAR(255) = '',
		@FirstName VARCHAR(60) = 'FIRST',
		@LastName VARCHAR(60) = 'LAST',
		@MiddleName VARCHAR(60) = '',
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
		@StackOverflowUrl VARCHAR(255) = '',
		@MediumUrl VARCHAR(255) = '',
		@PluralsightUrl VARCHAR(255) = ''

*/