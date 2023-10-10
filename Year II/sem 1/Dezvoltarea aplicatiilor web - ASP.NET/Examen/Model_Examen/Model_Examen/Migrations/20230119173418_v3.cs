using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace ModelExamen.Migrations
{
    /// <inheritdoc />
    public partial class v3 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "DateExp",
                table: "GiftCards",
                newName: "DataExp");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "DataExp",
                table: "GiftCards",
                newName: "DateExp");
        }
    }
}
