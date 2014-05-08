#/usr/bin/python
# encoding: UTF-8

from time import time

from intermine.webservice import Service
#service = Service("http://localhost:8080/malariamine/service")
service = Service("http://beta.flymine.org/beta/service")
#service = Service("http://www.mousemine.org/mousemine/service")

# Get a new query on the class (table) you will be querying:
query = service.new_query("Gene")

view = ["chromosomeLocation.start", "chromosomeLocation.end", "symbol", "primaryIdentifier", "organism.shortName"]
query.add_view(view)

# create some ranges to query (start, end, step)
ranges = []
for start in range(1, 100000, 10000):
	ranges.append("2L:%d..%d" % (start, start + 5000))
	#ranges.append("NC_002127.1:%d..%d" % (start, start + 10003))

print 'Querying %d ranges %s' % (len(ranges), str(ranges))

query.add_constraint("chromosomeLocation", "OVERLAPS", ranges)
query.add_sort_order("Gene.chromosomeLocation.start", "ASC")

print 'query:', query
print 'count:', query.count()

start_time = time()
for row in query.rows():
    line = [str(row[field]) for field in view]
    print ' '.join(line)

print 'Query for %d ranges took %.3fs' % (len(ranges), time() - start_time)

