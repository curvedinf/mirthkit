#ifndef _AVOCADO_H
#define _AVOCADO_H

#include "NameTable.h"
#include <sqlite3.h>

#define VAULT_DIR "./local/"
#define VAULT_EXT ".vault"
#define AV_QUERY_LENGTH 1024*1024*3

#define TABLE_CREATE "CREATE TABLE Vault (Name varchar UNIQUE, Value varchar);"

namespace ciga {
	NameTable<sqlite3> vaults;
	char _query[AV_QUERY_LENGTH];
	char _result[AV_QUERY_LENGTH];
	
	void _avFlush() 
	{
		List<sqlite3> vaultList;
		vaults.append(&vaultList);
		sqlite3* vault = vaultList.popFront();
		while(vault)
		{
			sqlite3_close(vault);
			vault = vaultList.popFront();
		}
		vaults.clear();
	}
	void store(char* vaultName, char* name, char* value)
	{
		sqlite3** vault = vaults.get(vaultName);
		if(!*vault)
		{
			char pathName[1024*32];
			
			//sprintf(pathName,"%s%s%s",VAULT_DIR,vaultName,VAULT_EXT);
			
			#ifdef LINUX_32
			char* homestr = getenv("HOME");
			sprintf(pathName,"%s/.mirthkit/%s%s",homestr,vaultName,VAULT_EXT);
			#endif
			
			#ifdef WIN32
			char* homestr = getenv("HOMEPATH");
			sprintf(pathName,"%s/MirthKit/%s%s",homestr,vaultName,VAULT_EXT);
			#endif
			
			#ifdef MAC_OSX
			char* homestr = getenv("HOME");
			sprintf(pathName,"%s/.mirthkit/%s%s",homestr,vaultName,VAULT_EXT);
			#endif
			
			sqlite3_open(pathName,vault);
			sqlite3_exec(*vault,TABLE_CREATE,0,0,0);
		}
		sprintf(_query,"REPLACE INTO Vault (Name,Value) VALUES ('%s','%s');",name,value);
		sqlite3_exec(*vault,_query,0,0,0);
	}
	
	int _avCallback(void* used,int numColumns,char** columns, char** columnNames)
	{
		*((bool*)used) = true;
		strcpy(_result,columns[0]);
		return 0;
	}
	
	char* retrieve(char* vaultName, char* name)
	{
		sqlite3** vault = vaults.get(vaultName);
		if(!*vault)
		{
			char pathName[1024*32];
			
			//sprintf(pathName,"%s%s%s",VAULT_DIR,vaultName,VAULT_EXT);
			
			#ifdef LINUX_32
			char* homestr = getenv("HOME");
			sprintf(pathName,"%s/.mirthkit/%s%s",homestr,vaultName,VAULT_EXT);
			#endif
			
			#ifdef WIN32
			char* homestr = getenv("HOMEPATH");
			sprintf(pathName,"%s/MirthKit/%s%s",homestr,vaultName,VAULT_EXT);
			#endif
			
			#ifdef MAC_OSX
			char* homestr = getenv("HOME");
			sprintf(pathName,"%s/.mirthkit/%s%s",homestr,vaultName,VAULT_EXT);
			#endif
			
			sqlite3_open(pathName,vault);
			if(sqlite3_exec(*vault,TABLE_CREATE,0,0,0)==SQLITE_OK) return 0;
		}
		char* error;
		sprintf(_query,"SELECT Value FROM Vault WHERE Name = '%s';",name);
		bool used = false;
		sqlite3_exec(*vault,_query,_avCallback,&used,0);
		if(!used) return 0;
		return _result;
	}
}

#endif /* _AVOCADO_H */
