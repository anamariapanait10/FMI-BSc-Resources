using Microsoft.CodeAnalysis.VisualBasic.Syntax;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ArticlesApp.Migrations
{
    /// <inheritdoc />
    public partial class AddAutoIncrementID : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropPrimaryKey("PK_ArticleBookmarks", "ArticleBookmarks");

            migrationBuilder.DropColumn(
                name: "Id",
                table: "ArticleBookmarks");

            migrationBuilder.AddColumn<int>(
                name: "Id",
                table: "ArticleBookmarks",
                type: "int",
                nullable: false
                )
                .Annotation("SqlServer:Identity", "1, 1");

            migrationBuilder.AddPrimaryKey(
                name: "PK_ArticleBookmarks",
                table: "ArticleBookmarks",
                columns: new string[] { "Id", "ArticleId", "BookmarkId" }
            );
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            
        }
    }
}
